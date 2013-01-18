# encoding: utf-8

require 'tire'
require 'tweetstream'

require 'yaml'
require 'colored'

# Twitter Stream API configuration.

begin
  raw_config = File.read("#{ENV['HOME']}/.credentials/services.yml")
  twitter = YAML.load(raw_config)['twitter']
rescue
  puts red { "\n\tError: problems with #{ENV['HOME']}/.credentials/services.yml\n" }
  exit(1)
end

# https://dev.twitter.com/apps (app: Tao Streams)

TweetStream.configure do |config|
  config.consumer_key       = twitter['consumer_key']
  config.consumer_secret    = twitter['consumer_secret']
  config.oauth_token        = twitter['oauth_token']
  config.oauth_token_secret = twitter['oauth_token_secret']
  config.auth_method        = :oauth
end

# Strip off fields we are not interested in.
# Flatten and clean up entities.

def handle_tweet(s)
  # tweetstream >= v2.0.0
  hashtags = s.hashtags.to_a.map { |o| o["text"] }
  urls = s.urls.to_a.map { |o| o["expanded_url"] }
  user_mentions = s.user_mentions.to_a.map { |o| o["screen_name"] }

  puts "-"*80
  puts s[:text].green
  puts "urls:          #{urls.inspect}".yellow
  puts "user_mentions: #{user_mentions.inspect}".yellow
  puts "hashtags:      #{hashtags.inspect}".yellow
end

# TweetStream part.

client = TweetStream::Client.new

client.on_error do |message|
  puts red message.red
end

# Fetch statuses from Twitter and write them to ElasticSearch.

client.track('rails', 'jquery', 'mongodb', 'couchdb', 'redis', 'neo4j', 'elasticsearch', 'riak') do |status|
  handle_tweet(status)
end