require 'bundler/setup'
require 'twitter'
require 'colored'
require 'yaml'

# https://dev.twitter.com/apps
#   My applications: Elasticsearch NoSQL
#
# --- credentials.yml
#
# login: me
# password: secret
# consumer_key: AAAAAAAAAAAAAAAAAAAAA
# consumer_secret: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
# oauth_token: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
# oauth_token_secret: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

credentials = ARGV

unless credentials[0]
  puts '\nUsage:'
  puts "\truby #{__FILE__} FILE_WITH_TWITTER_CREDENTIALS"
  puts '\truby fetch-tweets-simple.rb ~/.credentials/twitter.yml\n\n'
  exit(1)
end

begin
  raw_config = File.read File.expand_path(credentials[0])
  twitter = YAML.safe_load(raw_config)
rescue
  puts '\n\tError: problems with #{credentials}\n'.red
  exit(1)
end

def handle_tweet(s)
  puts "#{s[:created_at].to_s.cyan}:\t#{s[:text].yellow}"
end

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = twitter['consumer_key']
  config.consumer_secret     = twitter['consumer_secret']
  config.access_token        = twitter['oauth_token']
  config.access_token_secret = twitter['oauth_token_secret']
end

topics = %w(
  wow
  love
  mongodb elasticsearch couchdb neo4j redis
  rails d3js
  deeplearning
)

client.filter(track: topics.join(',')) do |status|
  handle_tweet status
end
