# -*- coding: utf-8 -*-

# Elasticsearch Guide
#
#     scan:  http://www.elasticsearch.org/guide/reference/api/search/search-type.html
#   scroll:  http://www.elasticsearch.org/guide/reference/api/search/scroll.html

# Ruby 2.0
#
# Net::HTTP: http://www.ruby-doc.org/stdlib-2.0/libdoc/net/http/rdoc/Net/HTTP.html
# https://github.com/augustl/net-http-cheat-sheet
#
# Gem Oj: http://www.ohler.com/oj/

require 'bundler/setup'
require 'oj'

# Oj.default_options = { symbol_keys: false, indent: 0 }
# puts Oj.default_options

# {
#    "_id" : "292709040247668737"
#    "created_at" : "2013-01-19T20:04:08+01:00",
#    "user_mentions" : [ "digitalocean", "etelsverdlov" ],
#    "text" : "RT @digitalocean: ...",
#    "hashtags" : [],
#    "urls" : [],
#    "screen_name" : "etelsverdlov",
#    "tag" : "rails"
# }

def handle_tweet(h)
  s = h['_source']
  r = { }
  r['_id'] = h['_id']
  r.merge(s)
end

require 'net/http'
# this will also `require 'uri'` so you don’t need to require it separately.

# scroll indicates for how long the nodes that participate in the
# search will maintain relevant resources in order to continue and
# support it
#
# 10 minutes should suffice to dump the tweets index

scan_uri = URI('http://localhost:9200/tweets/_search?search_type=scan&scroll=10m&size=32')

# scan = Net::HTTP.get(scan_uri)
# scan
# {
#   "_scroll_id":"c2NhbjsxOzk3OkpsWXNEVS03UU9LaHhhZVRLRVZfZkE7MTt0b3RhbF9oaXRzOjU5NDM7",
#   "took":1,
#   "timed_out":false,
#   "_shards":{"total":1,"successful":1,"failed":0},
#   "hits":{"total":5943,"max_score":0.0,"hits":[]}
# }

scroll_id = Oj::Doc.open(Net::HTTP.get(scan_uri)).fetch('_scroll_id')

loop do
  http = Net::HTTP.new('localhost', '9200')
  request = Net::HTTP::Get.new('/_search/scroll?scroll=10m')
  request.body = scroll_id

  response = http.request(request)
  array = Oj::Doc.open(response.body).fetch('/hits/hits')

  break if array.size == 0

  array.each do |tweet|
    puts Oj.dump(handle_tweet(tweet))
  end
end
