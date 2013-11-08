require "bundler/setup"

require 'tweetstream'   # http://rdoc.info/github/tweetstream/tweetstream
require 'colored'

require 'yaml'

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
  puts "\nUsage:"
  puts "\t#{__FILE__} FILE_WITH_TWITTER_CREDENTIALS"
  puts "\truby fetch-tweets-simple.rb ~/.credentials/twitter.yml"
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
#
#   My applications: Elasticsearch NoSQL

TweetStream.configure do |config|
  config.consumer_key       = twitter['consumer_key']
  config.consumer_secret    = twitter['consumer_secret']
  config.oauth_token        = twitter['oauth_token']
  config.oauth_token_secret = twitter['oauth_token_secret']
  config.auth_method        = :oauth
end

def handle_tweet(s)
  puts "#{s[:created_at].to_s.cyan}:\t#{s[:text].yellow}"
end

client = TweetStream::Client.new

client.on_error do |message|
  puts message
end

client.track('wow', 'mongodb', 'elasticsearch', 'couchdb', 'neo4j', 'redis', 'emberjs', 'meteorjs', 'd3js') do |status|
  handle_tweet status
end
