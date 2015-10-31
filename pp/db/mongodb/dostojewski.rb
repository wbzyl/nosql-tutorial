#! /usr/bin/env ruby

require 'bundler/setup'

# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'net/http'

# http://ruby-doc.org/stdlib/libdoc/logger/rdoc/index.html
require 'logger'

# https://docs.mongodb.org/ecosystem/drivers/ruby/
require 'mongo'

logger = Logger.new($stderr)
logger.level = Logger::WARN # set the default level: INFO, WARN

# English stopwords from Tracker, http://projects.gnome.org/tracker/
# GitHub: git clone git://git.gnome.org/tracker ; cd data/languages/

stop = IO.read('stopwords.en').split("\n")
logger.info "liczba wczytanych stopwords: #{stop.length}"

uri = 'http://www.gutenberg.org/cache/epub/2638/pg2638.txt'
filename = 'Dostoevsky_Feodor-The_Idiot.txt'

# Gutenberg

unless File.exist?(filename)
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

# read the file content in the DOS paragraph mode and remove empty paragraphs

# read DOS file; UNIX .readlines(filename, "")
data = IO.readlines(filename, "\n\r")
lines = data.map do |para|
  para.gsub!(/\s+/, ' ').strip
end

# delete empty strings and strip legal info (preamble and postable)
lines.delete('')
book = lines[12..-56]

logger.info "liczba wczytanych akapitów: #{book.size}"

# updated to MongoDB Driver 2.1.2

Mongo::Logger.logger = logger
Mongo::Logger.logger.level = Logger::WARN

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
coll = client[:dostojewski]

coll.drop

book.each_with_index do |para, n|
  words = para
          .gsub(/[!?;:"'().,\[\]*]/, '')
          .gsub('--', ' ')
          .tr('_', ' ')
          .gsub('\ufeff', '') # remove zero width no-break space in the title
          .downcase.split(/\s+/)
  words.each do |word|
    if stop.include?(word)
      logger.debug "skipped stopword: #{word}"
    else
      next if word.empty?
      letters = word.split('').sort.uniq
      coll.insert_one(
        word: word,
        para: n,
        letters: letters
      )
      logger.debug "word: #{word}, para: #{n}, letters: #{letters}\n"
    end
  end
end

puts 'Done!'
puts "\t  database: test"
puts "\tcollection: dostojewski"
puts "\t      size: #{coll.find.count}"
