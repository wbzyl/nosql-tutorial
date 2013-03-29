# Aggregation Examples

* imieniny
* ...

## Imieniny

Pobieramy plik
[imieniny.csv](https://raw.github.com/wbzyl/nosql-tutorial/master/pp/GeoIP/data/imieniny.csv)
i za pomocą tego polecenia zapisujemy dane z tego pliku w bazie *test*
i kolekcji *imieniny*:

```sh
mongoimport --drop --headerline --type csv --collection imieniny < imieniny.csv
```

Zaczynamy od sprawdzenia kolekcji *imieniny* w bazie *test*.
Kolekcja liczy 364 dokumenty:

```ruby
require 'mongo'
include Mongo

db = MongoClient.new("localhost", 27017, w: 1, wtimeout: 200, j: true).db("test")
coll = db.collection("imieniny")
coll.count #=> 364
coll.find_one
#=>
{
  "_id"=>BSON::ObjectId('51558a039779eb4112694a83'),
  "day"=>1, "month"=>1, "names"=>"Mieszka Mieczysława Marii"
}
coll.aggregate([ {"$group" => {_id: 0, count: {"$sum" => 1}}} ])
#=>
[{"_id"=>0, "count"=>364}]
```

Zaczniemy od przekształcenia danych na taki format:

```ruby
{
  "_id"=>BSON::ObjectId('515432e29779eb41126947bc'),
  "date"=>"18/01", "names"=>["Piotra", "Małgorzaty"]
}
```

Zmienimy format danych na konsoli *irb*:

```ruby
coll.find({}, {snapshot: true}).each do |doc|
  doc["names"] = doc["names"].split(" ")
  doc["date"] = "%02d/%02d" % [doc["day"], doc["month"]]
  doc.delete("day") ; doc.delete("month")
  coll.save(doc)
end
coll.count    #=> 364
coll.find_one
#=>
{
  "_id"=>BSON::ObjectId('51558a039779eb4112694a94'),
  "date"=>"18/01", "names"=>["Piotra", "Małgorzaty"]
}
```

## Przykładowe agregacje

1\. Jaka jest różnica między tymi agregacjami?

```ruby
puts coll.aggregate([
  {"$project" => {_id: 0, day: 1, month: 1, names: 1}},
  {"$limit" => 4},
  {"$unwind" => "$names"}
])

puts coll.aggregate([
  {"$project" => {_id: 0, day: 1, month: 1, names: 1}},
  {"$unwind" => "$names"},
  {"$limit" => 4}
])
```

2\. Prosty pivot – *names* ↺ *date*, gdzie pole `date` utworzymy
za pomocą operatora `$project` oraz
[string operators](http://docs.mongodb.org/manual/reference/aggregation/#string-operators):

```ruby
puts coll.aggregate([ {"$project" => { _id: 0, names: 1, date: { "$concat" => ["$day", "/", "$month"] }  }} ])


puts coll.aggregate([
  {"$project" => { _id: 0, names: 1, month: 1, day: 1}},
  {"$unwind"  => "$names"},
  {"$group" => { _id: "$names", count: {"$sum" => 1}}},
  {"$sort" => {count: -1}},
  {"$limit" => 20}
])
```

Ten sam wynik na dwa różne sposoby:

```ruby
puts coll.aggregate([
  {"$project" => { _id: 0, names: 1, month: 1, day: 1}},
  {"$unwind"  => "$names"},
  {"$group" => { _id: "$names", dates: {"$addToSet" => {"m" => "$month", "d" => "$day"}}}},
])

puts coll.aggregate([
  {"$project" => { _id: 0, names: 1, date: {m: "$month", d: "$day"} }},
  {"$unwind"  => "$names"},
  {"$group"   => { _id: "$names", dates: {"$addToSet" => "$date"} }},
])
```
