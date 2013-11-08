# encoding: utf-8

require 'tweetstream'
require 'tire'
require 'colored'

require 'yaml'

begin
  raw_config = File.read("#{ENV['HOME']}/.credentials/services.yml")
  twitter = YAML.load(raw_config)['twitter']
rescue
  puts "\n\tError: problems with #{ENV['HOME']}/.credentials/services.yml\n".red
  exit(1)
end

# https://dev.twitter.com/apps  (app: Tao Streams)
TweetStream.configure do |config|
  config.consumer_key       = twitter['consumer_key']
  config.consumer_secret    = twitter['consumer_secret']
  config.oauth_token        = twitter['oauth_token']
  config.oauth_token_secret = twitter['oauth_token_secret']
  config.auth_method        = :oauth
end

# Tire part.

# Let's define a class to hold our data in *ElasticSearch*.
class Tweet
  include Tire::Model::Persistence

  # property :id
  property :text
  property :screen_name
  property :created_at
  property :hashtags
  property :urls
  property :user_mentions

  # Let's define callback for percolation.
  # Whenewer a new document is saved in the index, this block will be executed,
  # and we will have access to matching queries in the `Tweet#matches` property.
  #
  # Below, we will just print the text field of matching query.
  on_percolate do
    if matches.empty?
      puts "'#{text}' from @#{screen_name}"
    else
      puts "'#{text.green}' from @#{screen_name.yellow}"
    end
  end
end

puts "\nYou can check out the statuses in your index with curl:\n".magenta
puts "  curl 'http://localhost:9200/tweets/_search?q=*&sort=created_at:desc&size=4&pretty=true'\n".yellow

# Strip off fields we are not interested in.
# Flatten and clean up entities.

def handle_tweet(s)
  # tweetstream >= v2.0.0
  hashtags = s.hashtags.to_a.map { |o| o["text"] }
  urls = s.urls.to_a.map { |o| o["expanded_url"] }
  user_mentions = s.user_mentions.to_a.map { |o| o["screen_name"] }

  h = Tweet.new id: s[:id].to_s,
    text: s[:text],
    screen_name: s[:user][:screen_name],
    created_at: s[:created_at],
    hashtags: hashtags,
    urls: urls,
    user_mentions: user_mentions

  types = h.percolate
  puts "matched queries: #{types}".cyan

  types.to_a.each do |type|
    Tweet.document_type type
    h.save
  end
end

# TweetStream part.

client = TweetStream::Client.new

client.on_error do |message|
  puts message.red
end

# Fetch statuses from Twitter and write them to ElasticSearch.
keywords = %w{rails jquery mongodb couchdb redis neo4j elasticsearch basho meteorjs emberjs backbonejs d3js}
client.track(*keywords) do |status|
  handle_tweet(status)
end
