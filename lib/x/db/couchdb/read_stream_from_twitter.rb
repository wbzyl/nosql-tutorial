#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'yajl'

require 'date'
require 'pp'

require 'couchrest'

unless ARGV[1]
  puts "Usage: read_stream_from_twitter PORT DBNAME\n"
  puts "Example: curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -uUser | read_stream_from_twitter.rb 4000 nosql"
  puts "Example: curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K credentials | read_stream_from_twitter.rb 4000 nosql"
  exit(0)
end

port = ARGV.shift
dbname = ARGV.shift
db = CouchRest.database!("http://127.0.0.1:#{port}/#{dbname}")

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
  hash['created_on'] ="#{date.year}-#{date.month}-#{date.day}-#{date.hour}-#{date.minute}-#{date.second}"

  db.save_doc(hash)
end
