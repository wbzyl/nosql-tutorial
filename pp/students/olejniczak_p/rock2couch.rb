#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

if RUBY_VERSION < "1.9.0"
  require 'rubygems'
end

STDERR.puts "Użycie: zamieniamy 'id' na '_id'"
STDERR.puts "#{$0} #{ARGV[0]} > oczyszczona_wersja.json"
STDERR.puts "Następnie:"
STDERR.puts " * w Futonie tworzymy bazę rock"
STDERR.puts ' * zapisujemy dokumenty: curl -X POST -H "Content-Type: application/json" --data @oczyszczona_wersja.json http://127.0.0.1:5984/rock/_bulk_docs'

require 'pp'
require 'yajl'

records = Yajl::Parser.new.parse(File.read(ARGV[0]))

data = records["docs"]

data.each do |artist|
  id = artist.delete("id")
  artist["_id"] = id
end

puts Yajl::Encoder.encode(records)
