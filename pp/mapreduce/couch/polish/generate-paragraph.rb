#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'bundler/setup'

require 'couchrest'

couch = CouchRest.new("http://localhost:5984")
DB = couch.database('wb')

WORD_MEMOIZER = {}

def probable_follower_for(start)
  WORD_MEMOIZER[start] ||= DB.view('app/markov', startkey: start, :endkey=>[start, {}].flatten, :group_level=>3)
  row = WORD_MEMOIZER[start]['rows'].sample # get random row (Ruby v1.9.2+)
  return row['key'][1,2]
end

bigram = ["★", "★"]
while true
  bigram = probable_follower_for(bigram)
  if bigram[1] == "◀"
    break
  else
    print "#{bigram[1]} "
  end
end

print "\n"
