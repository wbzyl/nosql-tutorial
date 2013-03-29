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

Zaczniemy zmiany formatu danych na:

```ruby
{
  "_id"=>BSON::ObjectId('515432e29779eb41126947bc'),
  "date"=>"18/01", "names"=>["Piotra", "Małgorzaty"]
}
```

Format zmienimy na konsoli *irb*:

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
  {"$project" => {_id: 0, date: 1, names: 1}},
  {"$limit" => 4},
  {"$unwind" => "$names"}
])

puts coll.aggregate([
  {"$project" => {_id: 0, date: 1, names: 1}},
  {"$unwind" => "$names"},
  {"$limit" => 4}
])
```

2\. Prosty pivot – *names* ↺ *date*:

```ruby
{ "date"=>"18/01", "names"=>["Piotra", "Małgorzaty"] }
{ "name"=>"Agnieszki", "dates"=>["20/04", "06/03", "21/01"] }
```

Aggregacja:

```ruby
puts coll.aggregate([
  {"$project" => { _id: 0, names: 1, date: 1}},
  {"$unwind"  => "$names"},
  {"$group" => { _id: "$names", dates: {"$addToSet" => "$date"}}},
  {"$project" => { name: "$_id", dates: 1, _id: 0}}
])
```

3\. Ile razy X obchodzi imieniny?

```ruby
puts coll.aggregate([
  {"$project" => { _id: 0, names: 1, date: 1}},
  {"$unwind"  => "$names"},
  {"$group" => { _id: "$names", count: {"$sum" => 1}}},
  {"$sort" => {count: 1}}
])
#=>
{"_id"=>"Piotra", "count"=>9}
{"_id"=>"Grzegorza", "count"=>9}
{"_id"=>"Marii", "count"=>16}
{"_id"=>"Jana", "count"=>21}
```
