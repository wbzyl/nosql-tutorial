#! /usr/bin/env ruby

require 'bundler/setup'

require 'elasticsearch'
require 'elasticsearch/extensions/ansi'

require 'awesome_print'

client = Elasticsearch::Client.new
client.transport.reload_connections!

# date fromats
#   https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-date-format.html
# ex. statuses.created_at: 2017-03-08 17:24:45 +0000

statuses_mapping = {
  mappings: {
    statuses: {
      properties: {
        created_at: { type: 'date', format: 'yyyy-MM-dd HH:mm:ss ZZ' },
        hashtags: { type: 'keyword' },
        text: { type: 'text', analyzer: 'english' }
      }
    }
  }
}

response = client.indices.create index: 'tweets', body: statuses_mapping

puts response.to_ansi
