# -*- coding: utf-8 -*-

require 'csv'
require 'mongo'
require 'time'

quotes  = CSV.read "goog.csv"

# Date,Open,High,Low,Close,Volume,Adj Close
# 2010-05-05,500.98,515.72,500.47,509.76,4566900,509.76

header = quotes.shift
h = header.map &:downcase

coll = Mongo::Connection.new("localhost", 27017).db("stock").collection("goog")

quotes.each do |row|
  d = Time.utc *row.shift.split("-").map(&:to_i)
  r = row.map &:to_f
  r.unshift d
  doc = Hash[ [h, r].transpose ]
  coll.insert doc
end

puts "Rekordow w bazie: #{coll.count()}"
