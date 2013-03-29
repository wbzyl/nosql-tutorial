# Aggregation Example – Name Days

Pobieramy plik
[name_days.json](https://raw.github.com/wbzyl/nosql-tutorial/master/pp/GeoIP/data/name_days.json)
i za pomocą tego polecenia zapisujemy dane z tego pliku w bazie *test*
i kolekcji *cal*:

```sh
mongoimport --drop --collection cal < name_days.json
```

Zaczynamy od sprawdzenia czy cała kolekcja, 364 dokumenty,
*cal* została zaimportowana:

```ruby
require 'mongo'
include Mongo

db = MongoClient.new("localhost", 27017, w: 1, wtimeout: 200, j: true).db("test")
coll = db.collection("cal")
coll.count #=> 364
coll.find_one
#=>{"names"=>["Mieszka", "Mieczysława", "Marii"], "date"=>{"day"=>1, "month"=>1}}
```

Zaczniemy od zmiany formatu danych na:

```ruby
{"date"=>"18/01", "names"=>["Piotra", "Małgorzaty"]}
```

Format zmienimy na konsoli *irb*:

```ruby
coll.find({}, {snapshot: true}).each do |doc|
  date = doc.delete("date")
  doc["date"] = "%02d/%02d" % [date["day"], date["month"]]
  coll.save(doc)
end
coll.count
#=> 364
coll.find_one
#=> {"names"=>["Mieszka", "Mieczysława", "Marii"], "date"=>"01/01"}
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

4\. Ile jest różnych imion?

```ruby
puts coll.aggregate([
  {"$project" => { _id: 0, names: 1}},
  {"$unwind" => "$names" },
  {"$group" => {_id: 0, total: {"$sum" => 1}}}
])
#=>
{"_id"=>0, "total"=>1022}
```

4\. W którym miesiącu jest najwięcej imion?

Zmieniamy oryginalny format danych na taki („spłaszczamy” dokument)::

```ruby
{"day"=>18, "month"=>1, "names"=>["Piotra", "Małgorzaty"]}
```
Importujemy dane, ale tym razem do kolekcji *imiona*:

```sh
mongoimport --drop --collection imiona < name_days.json
```

Przekształcamy format danych do pożądanego formatu na konsoli *irb*:

```ruby
coll = db.collection("imiona")

coll.find({}, {snapshot: true}).each do |doc|
  date = doc.delete("date")
  doc["day"] = date["day"]
  doc["month"] = date["month"]
  coll.save(doc)
end
coll.count    #=> 364
coll.find_one
```

Agregacja:

```ruby
totals = coll.aggregate([
  {"$project" => { _id: 0, names: 1, month: 1}},
  {"$unwind" => "$names" },
  {"$group" => {_id: "$month", total: {"$sum" => 1}}},
  {"$sort" => {_id: 1}}
])
# sprawdzenie
totals.reduce(0) {|acc, doc| acc + doc["total"] }
#=> powinno być 1022
puts totals
#=>
{"_id"=>1,  "total"=>88}
{"_id"=>2,  "total"=>78}
{"_id"=>3,  "total"=>87}
{"_id"=>4,  "total"=>82}
{"_id"=>5,  "total"=>88}
{"_id"=>6,  "total"=>78}
{"_id"=>7,  "total"=>90}
{"_id"=>8,  "total"=>87}
{"_id"=>9,  "total"=>88}
{"_id"=>10, "total"=>87}
{"_id"=>11, "total"=>80}
{"_id"=>12, "total"=>89}
```

