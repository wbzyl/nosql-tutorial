require "bundler/setup"

# https://github.com/sferik/twitter, http://rdoc.info/github/sferik/twitter

require 'twitter'  # requires version ~> 5.0.0.rc1
require 'colored'
require 'elasticsearch'

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
  puts "\truby fetch-tweets-simple.rb ~/.credentials/twitter.yml\n"
  exit(1)
end

begin
  raw_config = File.read File.expand_path(credentials[0])
  twitter = YAML.load(raw_config)
rescue
  puts "\n\tError: problems with #{credentials}\n".red
  exit(1)
end


# strip off fields we are not interested in
# flatten and clean up entities

def handle_tweet(s)
  # s.class -> Twitter.Tweet

  hashtags = s.hashtags.to_a.map { |o| o["text"] }
  urls = s.urls.to_a.map { |o| o["expanded_url"] }
  user_mentions = s.user_mentions.to_a.map { |o| o["screen_name"] }

  puts s[:text]
end

# def handle_tweet(s)
#   # tweetstream >= v2.0.0
#   hashtags = s.hashtags.to_a.map { |o| o["text"] }
#   urls = s.urls.to_a.map { |o| o["expanded_url"] }
#   user_mentions = s.user_mentions.to_a.map { |o| o["screen_name"] }

#   h = Tweet.new id: s[:id].to_s,
#     text: s[:text],
#     screen_name: s[:user][:screen_name],
#     created_at: s[:created_at],
#     hashtags: hashtags,
#     urls: urls,
#     user_mentions: user_mentions

#   types = h.percolate
#   puts "matched queries: #{types}".cyan

#   types.to_a.each do |type|
#     Tweet.document_type type
#     h.save
#   end
# end

# https://dev.twitter.com/apps
#
#   My applications: Elasticsearch NoSQL

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = twitter['consumer_key']
  config.consumer_secret     = twitter['consumer_secret']
  config.access_token        = twitter['oauth_token']
  config.access_token_secret = twitter['oauth_token_secret']
end

topics = ['ruby', 'rails', 'mongodb', 'elasticsearch', 'couchdb', 'neo4j', 'redis', 'emberjs', 'meteorjs', 'd3js']

client.filter(track: topics.join(",")) do |status|
  handle_tweet status
end


__END__

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
