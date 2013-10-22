#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'net/http'

# http://www.ruby-doc.org/ruby-1.9/classes/Logger.html
require 'logger'
logger = Logger.new(STDERR)
logger.level = Logger::INFO  # set the default level: INFO, WARN

require 'mongo'
include Mongo

# English stopwords from Tracker, http://projects.gnome.org/tracker/
# GitHub: git clone git://git.gnome.org/tracker ; cd data/languages/

stop = IO.read('stopwords.en').split("\n")
logger.info "liczba wczytanych stopwords: #{stop.length}"

uri = 'http://www.gutenberg.org/cache/epub/2638/pg2638.txt'
filename = 'Dostoevsky_Feodor-The_Idiot.txt'

dbname = 'test'
collection = 'dostojewski'


# Gutenberg

unless File.exists?(filename)
  url = URI.parse(uri)
  req = Net::HTTP::Get.new(url.path)
  logger.info "connecting to #{url.host}"
  res = Net::HTTP.start(url.host, url.port) do |http|
    http.request(req)
  end
  logger.info "done: #{res.code}"
  logger.info "writing to #{filename}"
  File.open(filename, 'w') do |f|
    f.write(res.body)
  end
end

# read the file content in the „DOS” paragraph mode and remove empty paragraphs

# data[4065]
# => "\nGania began, but did not finish. The two--father and son--stood before\r\none another, both unspeakably agitated, especially Gania.\r\n\r"
# data[4065].gsub!(/\s+/, " ")
# => " Gania began, but did not finish. The two--father and son--stood before one another, both unspeakably agitated, especially Gania. "

data = IO.readlines(filename, "\n\r") # read DOS file; UNIX .readlines(filename, "")
lines = data.map do |para|
  para.gsub!(/\s+/, " ").strip
end

# delete empty strings and strip legal info (preamble and postable)

lines.delete("")
book = lines[12..-56]
logger.info "liczba wczytanych akapitów: #{book.size}"

# updated to MongoDB Driver 1.9.2

# connection = Mongo::Connection.new("localhost", 27017)
# connection.drop_database(dbname)

connection = MongoClient.new("localhost", 27017)
# connection.drop_database(dbname)

db = connection.db(dbname)
# db.authenticate("username", "password") # authenticate

db.drop_collection(collection)

coll = db.collection(collection)

book.each_with_index do |para, n|
  words = para
    .gsub(/[!?;:"'().,\[\]*]/, "")
    .gsub("--", " ")
    .gsub("_", " ")
    .gsub("\ufeff", "") # remove zero width no-break space in the title
    .downcase.split(/\s+/)
  words.each do |word|
    if stop.include?(word)
      logger.debug "skipped stopword: #{word}"
    else
      next if word.empty?
      letters = word.split("").sort.uniq
      coll.insert({
        word: word,
        para: n,
        letters: letters
      })
      logger.debug "word: #{word}, para: #{n}, letters: #{letters}\n"
    end
  end
end

logger.info "MongoDB:"
logger.info "\t  database: #{dbname}"
logger.info "\tcollection: #{collection}"
logger.info "\t     count: #{coll.count}"
