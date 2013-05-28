#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'bundler/setup'

# Tekst książek pochodzi z „Wirtualna Biblioteka Literatury Polskiej”
#   http://literat.ug.edu.pl/books.htm

# http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
require 'net/http'

# http://www.ruby-doc.org/ruby-1.9/classes/Logger.html
require 'logger'
logger = Logger.new(STDERR)
logger.level = Logger::INFO  # set the default level: INFO, WARN

# documentation: http://www.couchrest.info/
require 'couchrest'

filename = 'sienkiewicz/potop.txt'

dbname = 'wb' # wirtualna biblioteka

# read the file content in the „DOS” paragraph mode and remove empty paragraphs
# data = IO.readlines(filename, "\n\r") # DOS file

data = IO.readlines(filename, "") # UNIX file
lines = data.map do |para|
  para.gsub(/\s+/, " ").strip
end

# check lines
class AssertionError < RuntimeError
end
def assert &block
  raise AssertionError unless yield
end
assert do
  lines.all? { |line| line.size > 5 } # all lines should not be empty
end

# Import Paragraphs to CouchDB

db = CouchRest.database!("http://127.0.0.1:5984/#{dbname}")

n = 1

lines.each_slice(200) do |slice|
  docs = []
  slice.each do |para|
    docs.push( { n: n, p: para, author: "Sienkiewicz, Henryk", title: "Potop" } )
    n += 1
  end
  db.bulk_save(docs)
  docs = []
  # break if n > 15
end

logger.info "CouchDB:"
logger.info "\t  database: #{dbname}"
logger.info "\t     count: #{lines.length}"
