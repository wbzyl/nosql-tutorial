# -*- coding: utf-8 -*-

require 'bookmark'

puts "Bookmark App (v2.0)"
puts ""

while true do 
  print "Wpisz URL (koniec -- Enter): "
  break if ((url = gets.chomp) == "")

  print "Opis: "
  title = gets.chomp

  print "Otaguj: "
  #tags = gets.chomp.split
  tags = gets.split  
  
  b = Bookmark.new :url => url, :title => title, :tags => tags
  
  puts "Zapisuję bookmark: #{b.inspect}"
  b.save

  puts ""
end
