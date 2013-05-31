#! /bin/env ruby

require 'bundler/setup'

require 'mongo'

class Line
  attr_reader :total_chars

  def initialize(fname)
    @file = File.new(fname)
    @total_chars = 0
  end

  def get_word
    word = ""
    @file.each_char do |x|
      @total_chars += 1
      if x == " " || @file.eof?
        break
      else
        word += x
      end
    end
    return word
  end
end

include Mongo

client = MongoClient.new('localhost', 27017)
db     = client['test']
coll   = db['trigrams']

line = Line.new('text8')

trigram = [line.get_word, line.get_word, line.get_word]

puts "#{trigram}"

n = 1

while true
  word = line.get_word
  if word.empty?
    break
  else
    trigram.push(word).shift
    # puts "#{trigram}"
    coll.insert( { _id: n, t: trigram} )
    n += 1
  end
end

puts "Total chars: #{line.total_chars}"
