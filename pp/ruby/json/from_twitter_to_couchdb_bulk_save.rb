# encoding: UTF-8

require 'yajl/version' # dziwne?
require 'yajl/http_stream'

require 'couchrest'

unless keywords = ARGV[0]
  puts "\nUsage: ruby from_twitter_to_couchdb_bulk_save.rb KEYWORD\n\n"
  exit(0)
end

db = CouchRest.database!("http://127.0.0.1:4000/twitter")

hash = Yajl::HttpStream.get("http://search.twitter.com/search.json?&lang=en&rpp=100&q=#{keywords}")
db.bulk_save(hash["results"])
