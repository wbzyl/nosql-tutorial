# encoding: UTF-8

require 'yajl/version' # dziwne?
require 'yajl/http_stream'

require 'mongo'

unless keywords = ARGV[0]
  puts "\nUsage: ruby from_twitter_to_mongodb_bulk_insert.rb KEYWORD\n\n"
  exit(0)
end

db = Mongo::Connection.new("localhost", 9000).db("twitter")
coll = db.collection("mongo")

hash = Yajl::HttpStream.get("http://search.twitter.com/search.json?&lang=en&rpp=100&q=#{keywords}")

coll.insert(hash["results"])

puts coll.count()
