# encoding: utf-8

require "rubygems"
require "bundler/setup"

require "elasticsearch"
require "tweetstream"
require "colored"
require "oj"

mapping =  {
  :properties => {
    :text          => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball'       },
    :screen_name   => { :type => 'string', :index => 'not_analyzed'                                },
    :created_at    => { :type => 'date'                                                            },
    :hashtags      => { :type => 'string', :index => 'not_analyzed', :index_name => 'hashtag'      },
    :urls          => { :type => 'string', :index => 'not_analyzed', :index_name => 'url'          },
    :user_mentions => { :type => 'string', :index => 'not_analyzed', :index_name => 'user_mention' }
  }
}

# track=mongodb,elasticsearch,couchdb,neo4j,redis,emberjs,meteorjs,d3js

track = %w[
  mongodb elasticsearch couchdb neo4j redis emberjs meteorjs d3js
]

# http://rubydoc.info/gems/elasticsearch-transport

client = Elasticsearch::Client.new log: true

# client.perform_request :delete, '/tweets'

#      perform_request method,  path,  params = {}, body = nil
client.perform_request :put,   '/tweets'  # create ‘tweets’ index

# http://rubydoc.info/gems/elasticsearch-api

# client.indices.put_mapping index: 'tweets', type: 'mongodb', body: {
#   mongodb: {
#     properties: {
#       text: { type: 'string', boost: 2.0, analyzer: 'snowball' },
#       screen_name: { type: 'string', index: 'not_analyzed' },
#       created_at: { type: 'date' },
#       hashtags: { type: 'string', index: 'not_analyzed', index_name: 'hashtag' },
#       urls: { type: 'string', index: 'not_analyzed', index_name: 'url' },
#       user_mentions: { type: 'string', index: 'not_analyzed', index_name: 'user_mention' }
#     }
#   }
# }

track.each do |keyword|
  client.indices.put_mapping index: 'tweets', type: keyword, body: mapping
end

# client.indices.get_mapping index: 'tweets', type: 'mongodb'

client.indices.refresh index: 'tweets'

# register several queries for percolation against the tweets index

track.each do |keyword|
  client.index index: '_percolator', type: 'tweets', id: keyword, body: { query: { query_string: { query: keyword } } }
end

client.indices.refresh index: '_percolator'
