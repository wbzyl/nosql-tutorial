#!/usr/bin/env ruby

require 'couchrest'

couch = CouchRest.new("http://localhost:5984")
DB = couch.database('gutenberg')
WORD_MEMOIZER = {}

def probable_follower_for(word)
  WORD_MEMOIZER[word] ||= DB.view('wc/markov', :startkey=>[word,nil], :endkey=>[word,{}], :group_level=>3)
  row = WORD_MEMOIZER[word]['rows'].sample # get random row (ruby 1.9.2)
  row['key'][1]
end

word = ARGV[0]

max_words = 44
counter = 0
while word && counter < max_words
  print word, " "
  word = probable_follower_for(word)
  counter += 1
end
print "\n"
