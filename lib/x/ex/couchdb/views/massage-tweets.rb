#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

if RUBY_VERSION < "1.9.0"
  require 'rubygems'
end

require 'couchrest'
require 'pp'

db = CouchRest.database("http://127.0.0.1:5984/nosql")
pager = CouchRest::Pager.new(db)

out = CouchRest.database!("http://127.0.0.1:5984/nosql-slimmed")

pager.all_docs do |slice|
  chunk = slice.map do |element|
    doc = db.get(element["id"])
    {
      "_id" => doc["_id"],
      "text" => doc["text"],
      :lang => doc["user"]["lang"],
      :screen_name => doc["user"]["screen_name"]
    }
  end
  out.bulk_save(chunk)
end
