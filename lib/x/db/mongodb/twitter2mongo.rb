# -*- coding: utf-8 -*-
require 'rubygems'
require 'yajl/http_stream'
require 'mongo'

unless keyword = ARGV[0]
  puts "\nUsage: ruby #{$0} KEYWORD\n\n"
  exit(0)
end

# zakładamy domyślny port na którym jest uruchomiony server mongod
db = Mongo::Connection.new("localhost", 27017).db("twitter")
coll = db.collection(keyword)

hash = Yajl::HttpStream.get("http://search.twitter.com/search.json?&lang=en&rpp=100&q=#{keyword}")

# tablica ze statusami jest zapisana w hash["results"]
# można się o tym przekonać wykonując polecenie:
#   curl 'http://search.twitter.com/search.json?&rpp=2&q=mongo'
# zapisujemy hurtem w kolekcji elementy tej tablicy
coll.insert(hash["results"])

puts "Liczba rekordów zapisanych w bazie 'twitter' w kolekcji '#{keyword}': #{coll.count()}"
