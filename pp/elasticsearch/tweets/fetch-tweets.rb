# -*- coding: utf-8 -*-
require "bundler/setup"

# https://github.com/sferik/twitter,
# http://rdoc.info/github/sferik/twitter
require 'twitter'  # we need at least this version 5.0.0.rc1

require 'colored'
require 'elasticsearch'

require 'yaml'

class Tweet
  attr_accessor :status, :id

  def initialize(status)
    @id = status[:id].to_s
    @status = cleanup(status)
  end

private

  # strip off fields we are not interested in
  # flatten and clean up entities
  def cleanup(s)
    # use these fields:
    #   :created_at, :text, :screen_name,
    #   :hashtags, :urls, :user_mentions
    hashtags = s.hashtags.to_a.map { |o| o["text"] }
    urls = s.urls.to_a.map { |o| o["expanded_url"] }
    user_mentions = s.user_mentions.to_a.map { |o| o["screen_name"] }
    {
      text: s[:text],
      screen_name: s[:user][:screen_name],
      created_at: s[:created_at],
      hashtags: hashtags,
      urls: urls,
      user_mentions: user_mentions
    }
  end
end

# ----

credentials = ARGV

unless credentials[0]
  puts "\nUsage:"
  puts "\t#{__FILE__} FILE_WITH_TWITTER_CREDENTIALS"
  puts "\truby fetch-tweets.rb ~/.credentials/twitter.yml\n\n"
  exit(1)
end

begin
  raw_config = File.read File.expand_path(credentials[0])
  twitter = YAML.load(raw_config)
rescue
  puts "\n\tError: problems with #{credentials}\n".red
  exit(1)
end

# https://dev.twitter.com/apps
#   My applications: Elasticsearch NoSQL

twitter_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = twitter['consumer_key']
  config.consumer_secret     = twitter['consumer_secret']
  config.access_token        = twitter['oauth_token']
  config.access_token_secret = twitter['oauth_token_secret']
end

elasticsearch_client = Elasticsearch::Client.new

topics = %w[
  deeplearning
  mongodb elasticsearch couchdb neo4j redis
  emberjs meteorjs rails
  d3js
]

twitter_client.filter(track: topics.join(",")) do |status|
  tweet = Tweet.new(status)
  result = elasticsearch_client.percolate index: 'tweets', body: { doc: tweet.status }

  puts "#{tweet.status[:created_at].to_s.cyan}:  #{tweet.status[:text].yellow}"
  puts "percolated query: #{result["matches"]}".green

  result["matches"].each do |type|
    elasticsearch_client.index index: "tweets", type: type, id: tweet.id,
      body: tweet.status
  end
end

# You can check out the statuses in your index with curl
#   curl -s 'http://localhost:9200/tweets/_search?q=*&sort=created_at:desc&size=4' | jq .
