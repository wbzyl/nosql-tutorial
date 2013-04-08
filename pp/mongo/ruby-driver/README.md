# Docs

* [http://docs.mongodb.org/manual/core/read/](http://docs.mongodb.org/manual/core/read/)
* [MongoDB Aggregation III: Map-Reduce Basics](http://kylebanker.com/blog/2009/12/mongodb-map-reduce-basics/)
* [Mongoid: MapReduce](http://mongoid.org/en/mongoid/docs/querying.html)
* [mongo ruby driver API](http://api.mongodb.org/ruby/current/Mongo/Collection.html#map_reduce-instance_method)

Stackoverflow:

* [MongoDB and MongoRuby: Sorting on mapreduce](http://stackoverflow.com/questions/7741734/mongodb-and-mongoruby-sorting-on-mapreduce)
* [Mining Twitter data with Ruby, MongoDB and Map-Reduce](http://gregmoreno.wordpress.com/2012/09/05/mining-twitter-data-with-ruby-mongodb-and-map-reduce/)


Konsola MongoDB:

```js
coll = db.students

fields = {_id:0, index:1, class_name:1, last_name:1, first_name:1, presences:1}

when = ["02-28", "03-06", "03-13", "04-03", "04-03", "03-23", "03-24", "04-06", "04-07"]
order = {class_name: 1, last_name: 1, first_name: 1}

coll.find({}, fields)

res = coll.find({presences: {$in: when}}, fields).sort(order)
res = coll.find({presences: {$size: 4}}, fields).sort(order)

res = coll.find({$where: "this.presences.length > 1"}, fields).sort(order)
```

Konsola Ruby:

```ruby
require "mongo"
include Mongo

db = MongoClient.new("localhost", 27017, w: 1).db("test")
coll = db.collection("students")
coll.count

```

## TODO

Mongoid: ustawić default: `presences = []`.

```js
coll.find({presences: null}, fields)
res = coll.find({$where: "this.presences && this.presences.length > 1"}, fields)
```
