#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'couchrest'
require 'pp'

#couch = CouchRest.new("http://sigma.ug.edu.pl:5984")

couch = CouchRest.new("http://localhost:5984")
db = couch.database('gutenberg')

puts "Now that we've parsed all those books into CouchDB,"
puts "the queries we can run are incredibly flexible."
puts "\nThe simplest query we can run is the total word"
puts "count for all words in all documents:"
puts "this will take a few minutes the first time."
puts "If it times out, just rerun this script in a few few minutes."
puts ""
pp db.view('app/wc')

puts "\nWe can also narrow the query down to just one word across all documents."
puts "Here is the count for 'YELP' in all books:"
puts ""

word = 'yelp'
params = {
  :startkey => [word],
  :endkey => [word, {}],
  :group_level => 2
  }
pp db.view('app/wc', params)

puts "\nWe scope the query using startkey and endkey params"
puts "to take advantage of CouchDB's collation ordering."
puts "\nWe can also count words on a per-title basis."
puts "Here is the count for 'YOUTH' in 'THE IDIOT':"
puts ""

params = {
  :key => ['youth', 'the idiot']
}
pp db.view('app/wc', params)

#puts ""
#puts "The url looks like this:"
#puts "\n\thttp://localhost:5984/gutenberg/_design/app/_view/wc?key=[\"youth\",\"the idiot\"]"
#puts "\nTry dropping that in your browser..."
