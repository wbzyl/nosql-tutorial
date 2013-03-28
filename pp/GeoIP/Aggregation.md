# Aggregation Examples

* imieniny
* ...

## Imieniny

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
  "_id"=>BSON::ObjectId('515432e29779eb41126947bc'),
  "day"=>18, "month"=>1, "names"=>["Piotra", "Małgorzaty"]
}
coll.aggregate([ {"$group" => {_id: 0, count: {"$sum" => 1}}} ])
#=>
[{"_id"=>0, "count"=>364}]
```

Nieco bardziej skomplikowane agregacje.

Jaka jest różnica między tymi agregacjami?

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

Prosty pivot – *names* ↺ *date*:

```ruby
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
