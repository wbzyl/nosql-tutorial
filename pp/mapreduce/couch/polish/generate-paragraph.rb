#! /usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'couchrest'

class Generator
  def initialize(couch, db)
    couch = CouchRest.new("http://localhost:5984")
    @db = couch.database('wb')
  end

  def run
    bigram = ["★", "★"]
    while true
      bigram = probable_follower_for(bigram)
      if bigram[1] == "◀"
        break
      else
        print "#{bigram[1]} "
      end
    end
  end

private

  def probable_follower_for(start)
    view = @db.view('app/markov', startkey: start, :endkey=>[start, {}].flatten, :group_level=>3)
    row = view['rows'].sample # get random row (Ruby v1.9.2+)
    return row['key'][1,2]
  end

end

generator = Generator.new("http://localhost:5984", "wb")
generator.run
print "\n"
