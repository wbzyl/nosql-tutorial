#! /usr/bin/env ruby

# Usage:
#   bunzip2 -c groceries.txt.bz2 | ./import_groceries.rb

require 'bundler/setup'
require 'mongo'

Mongo::Logger.level = Logger::INFO

client = Mongo::Client.new('mongodb://localhost:27017/test')
coll = client[:groceries]
coll.drop

ARGF.each_line do |line|
  puts "transaction: #{ARGF.lineno}"
  coll.insert_one(_id: ARGF.lineno, t: line.rstrip.split(',').sort)
end

# db.groceries.find({ t: { $all: [ "margarine", "butter" ] } })
