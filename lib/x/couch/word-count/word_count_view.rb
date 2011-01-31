#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'couchrest'
require 'pp'

couch = CouchRest.new("http://127.0.0.1:4000")
db = couch.database('gutenberg')

puts "Now that we've parsed all those books into CouchDB,"
puts "the queries we can run are incredibly flexible."
puts "\nThe simplest query we can run is the total word"
puts "count for all words in all documents:"
puts "this will take a few minutes the first time. if it times out,"
puts "just rerun this script in a few few minutes."

pp db.view('wc/word_count')

puts "\nWe can also narrow the query down to just one word across all documents."
puts "Here is the count for 'very' in all books:"

word = 'very'
params = {
  :startkey => [word], 
  :endkey => [word, {}]
  }
pp db.view('wc/word_count', params)

puts "\nWe scope the query using startkey and endkey params"
puts "to take advantage of CouchDB's collation ordering."
puts "\nWe can also count words on a per-title basis."
puts "Here is the count for 'very' in the-sign-of-the-four book:"

title = 'the sign of the four'
params = {
  :key => [word, title]
}
pp db.view('wc/word_count', params)

puts "\nHere are the params for 'very' in the the-sign-of-the-four book:"
puts params.inspect
puts
puts "The url looks like this:"
puts "\n\thttp://localhost:4000/gutenberg/_design/wc/_view/word_count?key=[\"very\",\"the sign of the four\"]"
puts "\nTry dropping that in your browser..."
