#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# http://www.ruby-doc.org/ruby-1.9/classes/Logger.html
require 'logger'
logger = Logger.new(STDERR)
logger.level = Logger::INFO  # set the default level: INFO, WARN

require 'mongo'

#book = '103.txt'
book = 'Dostoevsky_Feodor-The_Idiot.txt'

dbname = 'gutenberg'
collection = 'dostojewski'

connection = Mongo::Connection.new("localhost", 27017)

connection.drop_database(dbname)
db = connection.db(dbname)

coll = db.collection(collection)

data = IO.readlines(book, "")  # paragraph mode

# puts "#{data[8]}"
# puts "#{data[10]}"

logger.info "wczytano akapitów: #{data.length}"

data.each_with_index do |para, n|
  words = para.gsub(/[!?;:"'().,\[\]*]/,"").gsub("--"," ").downcase.split(/\s+/)
  words.each do |word|
    letters = word.split("").sort.uniq
    coll.insert({
      word: word,
      para: n,
      letters: letters
    })
    logger.debug "word: #{word}, para: #{n}, letters: #{letters}\n"
  end
end

logger.info "MongoDB:"
logger.info "\t  database: #{dbname}"
logger.info "\tcollection: #{collection}"
logger.info "\t     count: #{coll.count}"
