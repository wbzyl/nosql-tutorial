#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems' unless defined? Gem

# MongoDB Ruby Driver Tutorial:
#   http://api.mongodb.org/ruby/current/file.TUTORIAL.html

require 'yajl/http_stream'
require 'mongo'
require 'term/ansicolor'

class String
  include Term::ANSIColor
end

if ARGV.size == 0
  print "   Usage:".red, "  ruby #{$0} KEYWORD COLLECTION DATABASE\n"
  print "Defaults:".green, "  ruby #{$0} KEYWORD twitter test\n"
  exit(0)
end

keyword = ARGV[0]
collection = ARGV[1] || "twitter"
database = ARGV[2] || "test"

# zakładamy, że server mongod jest uruchomiony na localhost:27017

db = Mongo::Connection.new("localhost", 27017).db(database)
coll = db.collection(collection)

hash = Yajl::HttpStream.get("http://search.twitter.com/search.json?&lang=en&rpp=40&q=#{keyword}")

# tablica ze statusami jest zapisana w hash["results"]
# można się o tym przekonać wykonując polecenie:
#   curl 'http://search.twitter.com/search.json?&rpp=2&q=mongo'
# zapisujemy hurtem w kolekcji elementy tej tablicy

text = hash["results"].collect { |x| {'text' => x['text']} }

text.each { |x| puts x['text'] }

coll.insert(text) # bulk insert

print "\nLiczba dokumentów w bazie ", database.yellow, " w kolekcji ", collection.green, " \##{coll.count()}\n".red
