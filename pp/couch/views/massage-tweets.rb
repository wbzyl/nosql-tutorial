#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems' unless defined? Gem

require 'date'
require 'couchrest'
require 'pp'

db = CouchRest.database("http://127.0.0.1:5984/nosql")
#db = CouchRest.database("http://sigma.ug.edu.pl:5984/nosql")
pager = CouchRest::Pager.new(db)

out = CouchRest.database!("http://127.0.0.1:5984/nosql-slimmed")
#out = CouchRest.database!("http://sigma.ug.edu.pl:5984/nosql-slimmed")

pager.all_docs do |slice|
  chunk = slice.map do |element|
    doc = db.get(element["id"])

    date = DateTime.parse(doc['created_at'])
    created_on =[date.year, date.month, date.day, date.hour, date.min, date.sec]
    {
      "_id" => doc["_id"],
      "text" => doc["text"],
      "entities" => doc["entities"],
      :screen_name => doc["user"]["screen_name"],
      "lang" => doc["user"]["lang"],
      "created_at" => doc["created_at"],
      "created_on" => created_on
    }
  end
  out.bulk_save(chunk)
end
