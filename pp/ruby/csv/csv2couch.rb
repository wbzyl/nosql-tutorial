#!/usr/bin/env ruby

require 'csv'
require 'couchrest'

unless ARGV[0] && ARGV[1]
  puts "Usage: ruby #{$0} CSV URI\n"
  puts "       ruby #{$0} goog.csv http://127.0.0.1:5984/goog"
  exit(0)
end

csv = ARGV.shift
uri = ARGV.shift
db = CouchRest.database!(uri)

quotes  = CSV.read csv

# Date,Open,High,Low,Close,Volume,Adj Close
# 2010-05-05,500.98,515.72,500.47,509.76,4566900,509.76

header = quotes.shift
h = header.map &:downcase

quotes.each do |row|
  d = row.shift.split("-").map &:to_i
  r = row.map &:to_f
  r.unshift d
  doc = Hash[ [h, r].transpose ]
  db.save_doc doc
end
