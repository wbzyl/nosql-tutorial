# encoding: utf-8

require "bundler/setup"

require "elasticsearch"
require "colored"

# http://rubydoc.info/gems/elasticsearch-api
# client.indices.put_mapping index: "tweets", type: "rails",
#   body: { rails: { properites: { created_at: { type: "date", format: "YYYY-MM-dd HH:mm:ss Z" } } } }

mapping = {
  properties: {
    created_at:    { type: 'date',   format:  'YYYY-MM-dd HH:mm:ss Z', store: true           },
    text:          { type: 'string', boost:    2.0,                    analyzer:  'snowball' },
    screen_name:   { type: 'string', index:   'not_analyzed'                                 },
    hashtags:      { type: 'string', index:   'not_analyzed'                                 },
    urls:          { type: 'string', index:   'not_analyzed'                                 },
    user_mentions: { type: 'string', index:   'not_analyzed'                                 }
#   _ttl:          { enabled: true,  default: '12w'                                          }
  }
}

topics = %w[
  deeplearning mongodb elasticsearch couchdb neo4j redis emberjs meteorjs rails d3js
]

# http://rubydoc.info/gems/elasticsearch-transport

elasticsearch_client = Elasticsearch::Client.new log: true

# elasticsearch_client.perform_request :delete, '/tweets'

elasticsearch_client.perform_request :put, '/tweets'  # create ‘tweets’ index

topics.each do |keyword|
  keyword_mapping = { }
  keyword_mapping[keyword.to_sym] = mapping
  elasticsearch_client.indices.put_mapping index: 'tweets', type: keyword,
    body: keyword_mapping
end

# elasticsearch_client.indices.get_mapping index: 'tweets', type: 'mongodb'

elasticsearch_client.indices.refresh index: 'tweets'

# register several queries for percolation against the tweets index

topics.each do |keyword|
  elasticsearch_client.index index: '_percolator', type: 'tweets', id: keyword, body: { query: { query_string: { query: keyword } } }
end

elasticsearch_client.indices.refresh index: '_percolator'
