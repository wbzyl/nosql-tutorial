# -*- coding: utf-8 -*-

require "bundler/setup"

require "elasticsearch"
require "colored"

mapping = {
  _ttl:            { enabled: true,  default: '16w'                               },
  properties: {
    created_at:    { type: 'date',   format: 'YYYY-MM-dd HH:mm:ss Z'              },
    text:          { type: 'string', index:  'analyzed',    analyzer:  'snowball' },
    screen_name:   { type: 'string', index:  'not_analyzed'                       },
    hashtags:      { type: 'string', index:  'not_analyzed'                       },
    urls:          { type: 'string', index:  'not_analyzed'                       },
    user_mentions: { type: 'string', index:  'not_analyzed'                       }
  }
}

topics = %w[
  deeplearning
  mongodb elasticsearch couchdb neo4j redis
  emberjs meteorjs rails
  d3js
]

elasticsearch_client = Elasticsearch::Client.new log: true
elasticsearch_client.perform_request :put, '/tweets'       # create ‘tweets’ index

topics.each do |topic|
  elasticsearch_client.indices.put_mapping index: 'tweets', type: topic,
      body: { topic: mapping }
end
elasticsearch_client.indices.refresh index: 'tweets'

# register several queries for percolation against the tweets index
topics.each do |topic|
  elasticsearch_client.index index: '_percolator', type: 'tweets', id: topic,
      body: { query: { query_string: { query: topic } } }
end
elasticsearch_client.indices.refresh index: '_percolator'

# elasticsearch_client.perform_request :delete, '/tweets'
# elasticsearch_client.indices.get_mapping index: 'tweets', type: 'mongodb'
