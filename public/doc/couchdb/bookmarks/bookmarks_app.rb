# -*- coding: utf-8 -*-

require 'bookmark'

puts "Bookmark App (v1.0)"
puts ""

b1 = Bookmark.new(
  :url => 'http://couchdb.apache.org',
  :title => 'Official Site',
  :tags => ['apache', 'couch', 'nosql'])

b2 = Bookmark.new(
  :url => 'http://www.couch.io/docs',
  :title => 'Couchio – Documentation',
  :tags => ['couch', 'nosql', 'documentation', 'faq'])

puts "Zapisuję bookmark: #{b1.inspect}"
b1.save!
puts "Zapisuję bookmark: #{b2.inspect}"
b2.save!

puts "Zapisano bookmarki"
