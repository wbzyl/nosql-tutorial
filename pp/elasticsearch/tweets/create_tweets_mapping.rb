require 'elasticsearch'
require 'awesome_print'

require 'hashie'

# curl -s 'localhost:9200/tweets/_search?q=*&sort=created_at:desc&size=4'
# curl -s 'localhost:9200/tweets/_search?q=*&from=0&size=4'
# curl localhost:9200/tweets/_count
# curl -X DELETE localhost:9200/tweets

# client = Elasticsearch::Client.new log: true

client = Elasticsearch::Client.new
client.transport.reload_connections!

# client.cluster.health

# "_index": "tweets"
# "_type": "statuses"
#
# "text": "For Big Banks, Regulation is the Mother of GPU Invention..."
# "created_at": "2017-03-03 15:50:14 +0000",
# "hashtags": ["Fintech", "regtech"]
# "urls": ["https://twitter.com/i/web/status/837690569346400257"]

response = client.search index: 'tweets', q: 'GPU'
# client.search index: 'tweets', body: { query: { match: { title: 'test' } } }

# puts results.to_json

# Using Hash Wrappers
#   https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-api

mash = Hashie::Mash.new response

# puts mash.hits.hits[4].to_json
ap mash.hits.hits[4]._source


__END__

client.indices.create index: 'myindex', body: {
  mappings: {
    tweets: {
      properties: {
        title: {
          type: 'string',
          analyzer: 'title_synonym'
        }
      }
    }
  }
}

client.index index: 'myindex', type: 'tweets', id: 1, body: { title: 'Quick Brown Fox' }
client.index index: 'myindex', type: 'tweets', id: 2, body: { title: 'Slow Black Dog' }
client.index index: 'myindex', type: 'tweets', id: 3, body: { title: 'Fast White Rabbit' }

client.indices.refresh index: 'myindex'
client.search index: 'myindex', q: 'title:test'

client.search index: 'myindex',
              body: {
                query: { match: { title: 'test' } },
                from: 10,
                size: 10
              }

client.msearch \
  body: [
    { search: { query: { match_all: {} } } },
    { index: 'myindex', type: 'mytype', search: { query: { query_string: { query: '"Test 1"' } } } },
    { search_type: 'count', search: { aggregations: { published: { terms: { field: 'published' } } } } }
  ]
