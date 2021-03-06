#! /usr/bin/env ruby

require 'bundler/setup'

require 'twitter'
require 'awesome_print'
require 'rainbow/ext/string'

require 'yaml'

credentials = ARGV

unless credentials[0]
  puts "\nUsage:"
  puts "\truby #{__FILE__} FILE_WITH_TWITTER_CREDENTIALS"
  puts "\truby fetch-tweets-simple.rb ~/.credentials/twitter.yml\n\n"
  exit(1)
end

begin
  raw_config = File.read File.expand_path(credentials[0])
  twitter = YAML.safe_load(raw_config)
rescue
  puts "\n\tError: problems with #{credentials}\n".color(:red)
  exit(1)
end

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = twitter['consumer_key']
  config.consumer_secret     = twitter['consumer_secret']
  config.access_token        = twitter['access_token']
  config.access_token_secret = twitter['access_token_secret']
end

# display only created_at and text fields
def handle_tweet(s)
  ap s.to_h.select { |key| [:created_at, :text].include?(key) }
end

# testing -- use high volume statuses
topics = %w(love women)
# low volume statuses
# topics = %w(mongodb elasticsearch neo4j redis rails deeplearning)

client.filter(track: topics.join(',')) do |status|
  handle_tweet status
end
