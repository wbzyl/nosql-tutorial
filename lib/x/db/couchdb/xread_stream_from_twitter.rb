#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'rubygems'

require 'yajl'

require 'date'
require 'pp'

require 'couchrest'

unless ARGV[0]
  puts "Usage: read_stream_from_twitter COUCH\n"
#  puts "Example: curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -uUser | read_stream_from_twitter.rb User:Pass 5984 nosql"
#  puts "Example: curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K credentials | read_stream_from_twitter.rb User:Pass 5984 nosql"
  puts "Example: curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -uUser | read_stream_from_twitter.rb http://localhost:5984/nosql"
  puts "Example: curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K credentials | read_stream_from_twitter.rb http://localhost:5984/nosql"
  exit(0)
end

#credentials = ARGV.shift
uri = ARGV.shift
puts "\nŁączenie z bazą: #{uri}\n"

# jeśli nie istnieje, to utwórz bazę
db = CouchRest.database!(uri)

ARGF.each do |json|
  # czasami w pobieranym strumieniu zapląta się pusty wiersz
  next if json.match(/^\s*$/)

  parser = Yajl::Parser.new(:pretty => true)

  begin
    hash = parser.parse(json)
  rescue
    puts "This can't happen: JSON Parsing ERROR"
    pp hash
    next
  end

  hash['_id'] = hash['id_str']
  hash.delete('id')
  hash.delete('id_str')

  date = DateTime.parse(hash['created_at'])
  hash['created_on'] ="#{date.year}-#{date.month}-#{date.day}-#{date.hour}-#{date.min}-#{date.sec}"

  # p 44 * '-'
  # p hash

  db.save_doc(hash)
end
