#! /usr/bin/env ruby

require 'bundler/setup'

# http://rdoc.info/github/sferik/twitter
require 'twitter' # https://github.com/sferik/twitter,
require 'elasticsearch'

require 'rainbow/ext/string'
require 'awesome_print'

require 'yaml'

# helper method
def slice(hash, *keys)
  Hash[[keys, hash.values_at(*keys)].transpose]
end

class Status
  attr_accessor :status, :id

  def initialize(status)
    @id = status.id.to_s
    @status = cleanup(status)
  end

  private

  # strip off fields we are not interested in and flatten entities:
  #   :created_at, :text, :screen_name,
  #   :hashtags, :urls, :user_mentions

  # https://github.com/sickill/rainbow
  def cleanup(s)
    hashtags = s.hashtags.to_a.map(&:text)
    urls = s.urls.to_a.map(&:expanded_url)
    user_mentions = s.user_mentions.to_a.map(&:screen_name)
    {
      language: s.lang,
      text: s.text,
      screen_name: s.user.screen_name,
      created_at: s.created_at,
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
  twitter = YAML.safe_load(raw_config)
rescue
  puts "\n\tError: problems with #{credentials}\n".red
  exit(1)
end

twitter_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = twitter['consumer_key']
  config.consumer_secret     = twitter['consumer_secret']
  config.access_token        = twitter['access_token']
  config.access_token_secret = twitter['access_token_secret']
end

# International Women's Day 2017
topics = %w(love women)

# topics = %w(deeplearning mongodb elasticsearch neo4j redis rails)

# https://www.elastic.co/guide/en/elasticsearch/reference/5.2/query-dsl-percolate-query.html
# http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#percolate-instance_method
elastic_client = Elasticsearch::Client.new

twitter_client.filter(track: topics.join(',')) do |status|
  tweet = Status.new(status)
  elastic_client.index index: 'tweets', type: 'statuses', id: tweet.id,
                       body: tweet.status
  ap slice(tweet.status, :language, :text, :created_at, :hashtags)
end
