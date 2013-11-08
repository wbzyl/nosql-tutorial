# encoding: utf-8
require 'tire'

tweets_mapping =  {
  :properties => {
    :text          => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball'       },
    :screen_name   => { :type => 'string', :index => 'not_analyzed',                               },
    :created_at    => { :type => 'date',                                                           },
    :hashtags      => { :type => 'string', :index => 'not_analyzed', :index_name => 'hashtag'      },
    :urls          => { :type => 'string', :index => 'not_analyzed', :index_name => 'url'          },
    :user_mentions => { :type => 'string', :index => 'not_analyzed', :index_name => 'user_mention' }
  }
}

mappings = { }
keywords = %w{rails jquery mongodb couchdb redis neo4j elasticsearch basho meteorjs emberjs backbonejs d3js}

keywords.each do |keyword|
  mappings[keyword.to_sym] = tweets_mapping
end

Tire.index('tweets') do
  delete
  create :mappings => mappings
end

Tire.index('tweets').refresh

# Register several queries for percolation against the tweets index.

Tire.index('tweets') do
  keywords.each do |keyword|
    register_percolator_query(keyword) { string keyword }
  end
end

# Refresh the `_percolator` index for immediate access.

Tire.index('_percolator').refresh
