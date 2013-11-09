# encoding: utf-8

require "bundler/setup"

require "elasticsearch"
require "colored"

mapping =  {
  :properties => {
    :text          => { :type    => 'string', :boost => 2.0,            :analyzer => 'snowball'       },
    :screen_name   => { :type    => 'string', :index => 'not_analyzed'                                },
    :created_at    => { :type    => 'date'                                                            },
    :hashtags      => { :type    => 'string', :index => 'not_analyzed', :index_name => 'hashtag'      },
    :urls          => { :type    => 'string', :index => 'not_analyzed', :index_name => 'url'          },
    :user_mentions => { :type    => 'string', :index => 'not_analyzed', :index_name => 'user_mention' },
    :_ttl          => { :enabled => true,     :default => "30d"                                       }
  }
}

topics = %w[
  mongodb elasticsearch couchdb neo4j redis emberjs meteorjs rails d3js
]

# http://rubydoc.info/gems/elasticsearch-transport

elasticsearch_client = Elasticsearch::Client.new log: true

# elasticsearch_client.perform_request :delete, '/tweets'

#      perform_request method,  path,  params = {}, body = nil
elasticsearch_client.perform_request :put,   '/tweets'  # create ‘tweets’ index

# http://rubydoc.info/gems/elasticsearch-api

# elasticsearch_client.indices.put_mapping index: 'tweets', type: 'mongodb', body: {
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

topics.each do |keyword|
  elasticsearch_client.indices.put_mapping index: 'tweets', type: keyword, body: mapping
end

# elasticsearch_client.indices.get_mapping index: 'tweets', type: 'mongodb'

elasticsearch_client.indices.refresh index: 'tweets'

# register several queries for percolation against the tweets index

topics.each do |keyword|
  elasticsearch_client.index index: '_percolator', type: 'tweets', id: keyword, body: { query: { query_string: { query: keyword } } }
end

elasticsearch_client.indices.refresh index: '_percolator'
