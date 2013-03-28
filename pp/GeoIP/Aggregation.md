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
#=> {
  "_id"=>BSON::ObjectId('515432e29779eb41126947bc'),
  "day"=>18, "month"=>1, "names"=>["Piotra", "Małgorzaty"]
}
coll.aggregate([ {"$group" => {_id: 0, count: {"$sum" => 1}}} ])
#=> [{"_id"=>0, "count"=>364}]
```

Nieco bardziej skomplikowane agregacje:

```ruby

```
