#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'couchrest'
require 'pp'

couch = CouchRest.new("http://sigma.ug.edu.pl:4000")
db = couch.database('gutenberg')

puts "Now that we've parsed all those books into CouchDB,"
puts "the queries we can run are incredibly flexible."
puts "\nThe simplest query we can run is the total word"
puts "count for all words in all documents:"
puts "this will take a few minutes the first time. if it times out,"
puts "just rerun this script in a few few minutes."

pp db.view('app/wc')

puts "\nWe can also narrow the query down to just one word across all documents."
puts "Here is the count for 'CAPTAIN' in all books:"

word = 'captain'
params = {
  :startkey => [word], 
  :endkey => [word, {}]
  }
pp db.view('app/wc', params)

puts "\n--------"

puts "\nWe scope the query using startkey and endkey params"
puts "to take advantage of CouchDB's collation ordering."
puts "\nWe can also count words on a per-title basis."
puts "Here is the count for 'CAPTAIN' in The Skull:"

params = {
  :key => ['captain', 'the skull']
}
pp db.view('app/wc', params)

puts "The url looks like this:"
puts "\n\thttp://sigma.ug.edu.pl:4000/gutenberg/_design/app/_view/wc?key=[\"very\",\"the skull\"]"
puts "\nLokalna baza?"
puts "\n\thttp://localhost:4000/gutenberg/_design/app/_view/wc?key=[\"very\",\"the skull\"]"
puts "\nTry dropping that in your browser..."
