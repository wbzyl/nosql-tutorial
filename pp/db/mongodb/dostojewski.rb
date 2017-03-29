#! /usr/bin/env ruby

require 'bundler/setup'

# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'net/http'

# https://docs.mongodb.org/ecosystem/drivers/ruby/
require 'mongo'

logger = Mongo::Logger.logger # get the wrapped logger

# http://ruby-doc.org/stdlib/libdoc/logger/rdoc/index.html
# logger levels: DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
logger_level = {
  debug: Logger::DEBUG,
  info: Logger::INFO,
  warn: Logger::WARN,
  error: Logger::ERROR,
  fatal: Logger::FATAL,
  unknown: Logger::UNKNOWN
}

# set default level to Logger::INFO
Mongo::Logger.level = logger_level[ARGV[0].to_s.downcase.to_sym] || Logger::INFO

# ----

# English stopwords from Tracker, http://projects.gnome.org/tracker/
# GitHub: git clone git://git.gnome.org/tracker ; cd data/languages/

stop = IO.read('stopwords.en').split("\n")
logger.info "liczba wczytanych stopwords: #{stop.length}"

uri = 'http://www.gutenberg.org/files/2638/2638-0.txt'
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

client = Mongo::Client.new('mongodb://localhost:27017/test')
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
      logger.debug "inserted: #{word}"
    end
  end
end

logger.info 'Done!'
logger.info "\t  database: test"
logger.info "\tcollection: dostojewski"
logger.info "\t      size: #{coll.find.count}"
