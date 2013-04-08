# -*- coding: utf-8 -*-

require "mongo"
include Mongo

db = MongoClient.new("localhost", 27017, w: 1).db("test")
coll = db.collection("students")

# puts coll.count #=> 113

classes = [["nosql", "Techologie NoSQL"], ["pz", "Projekt zespołowy"], ["asi", "Architektura serwisów WWW i Techniki internetowe (zaoczne)"]]
# dates = ["02-28", "03-06", "03-13", "04-03", "04-03", "03-23", "03-24", "04-06", "04-07"]

def print_list(collection, klass)
  id = klass[0]
  name = klass[1]

  fields = {"_id" => 0, "class_name" => 1, "last_name" => 1, "first_name" => 1}
  order  = { class_name: 1, last_name: 1 }

  puts "\n\t#{name}\n\n"
  # res = collection.find({ class_name: id, presences: {"$in" => dates} }, { fields: fields }).sort(order)
  res = collection.find({ class_name: id, "$where" => "this.presences.length > 0" }, { fields: fields }).sort(order)
  res.each do |doc|
    puts "  #{doc['last_name']}, #{doc['first_name']}"
  end
end

classes.each do |klass|
  print_list coll, klass
end
