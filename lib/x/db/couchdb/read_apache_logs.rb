#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'digest/md5'

require 'yajl'

require 'date'
require 'pp'

require 'couchrest'

unless ARGV[1]
  puts "Usage: #{$0} FILENAME DBNAME\n"
  puts "Example: #{$0} apache-logs http://localhost:5984/logs-2011"
  puts "  where logs conists of lines:"
  puts "      20/Mar/2011:01:18:16 +0100"
  puts "      20/Mar/2011:01:18:44 +0100"
  exit(0)
end

filename = ARGV.shift
uri = ARGV.shift

puts "\n\t #{filename} -> #{uri}\n\n"

# jeśli nie istnieje, to utwórz bazę
db = CouchRest.database!(uri)

# logi apacza:
#
# 20/Mar/2011:01:18:16 +0100
# 20/Mar/2011:01:19:39 +0100

months = {"Jan" => 1, "Feb" => 2, "Mar" => 3,
  "Apr" => 4, "May" => 5, "Jun" => 6,
  "Jul" => 7, "Aug" => 8, "Sep" => 9,
  "Oct" => 10, "Nov" => 11, "Dec" => 12}

total = 0
batch_size = 1000
batch = []

regex = /^(\d{2})\/(\w{3})\/(\d{4}):(\d{2}):(\d{2}):(\d{2}) \+\d{4}/

IO.foreach(filename) do |line|
  # czasami w pobieranym strumieniu zapląta się dziwny wiersz
  next unless (md = line.match(regex))
  #puts "#{md.length}: #{md[1]} / #{md[2]} / #{md[3]} : #{md[4]} : #{md[5]} : #{md[6]}"

  batch.push( {
    :_id => Digest::MD5.hexdigest(rand.to_s + line),
    :ping => [md[3].to_i, months[md[2]], md[1].to_i, md[4].to_i, md[5].to_i, md[6].to_i] }
  )
  if total == batch_size
    db.bulk_save(batch)
    total = 0
  end

  total += 1
end

db.bulk_save(batch)

puts "Liczba wczytanych rekordów: #{total}"
