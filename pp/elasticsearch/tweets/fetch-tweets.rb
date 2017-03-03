require 'bundler/setup'

# https://github.com/sferik/twitter,
# http://rdoc.info/github/sferik/twitter
require 'twitter'
require 'colored'
require 'elasticsearch'

require 'yaml'

class Status
  attr_accessor :status, :id

  def initialize(status)
    @id = status[:id].to_s
    @status = cleanup(status)
  end

  private

  # strip off fields we are not interested in
  # flatten and clean up entities
  # we use these fields:
  #   :created_at, :text, :screen_name,
  #   :hashtags, :urls, :user_mentions
  # puts "#{s.methods(all: false)}".red

  def cleanup(s)
    puts "language: #{s.lang}".red
    puts "#hashtags: #{s.hashtags.size}".bold if s.hashtags.any?
    hashtags = s.hashtags.to_a.map { |o| o['text'] }
    urls = s.urls.to_a.map { |o| o['expanded_url'] }
    user_mentions = s.user_mentions.to_a.map { |o| o['screen_name'] }
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

topics = %w(
  deeplearning
  mongodb elasticsearch neo4j redis
  rails
)

twitter_client.filter(track: topics.join(',')) do |status|
  tweet = Status.new(status)
  puts tweet.inspect
end

__END__

elasticsearch_client = Elasticsearch::Client.new

twitter_client.filter(track: topics.join(',')) do |status|
  tweet = Status.new(status)
  # result = elasticsearch_client.percolate index: 'tweets', body: { doc: tweet.status }

  # puts "#{tweet.status[:created_at].to_s.cyan}:  #{tweet.status[:text].yellow}"
  # puts "percolated query: #{result["matches"]}".green

#  result['matches'].each do |type|
#    elasticsearch_client.index index: "tweets", type: type, id: tweet.id,
#      body: tweet.status
#  end
end

# You can check out the statuses in your index with curl
#   curl -s 'http://localhost:9200/tweets/_search?q=*&sort=created_at:desc&size=4' | jq .
