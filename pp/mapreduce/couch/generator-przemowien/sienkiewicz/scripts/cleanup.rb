#! /bin/env ruby
#-*- coding: utf-8 -*-

File.readlines("potop.txt").each do |line|
  next if line.match('--------|ROZDZIAŁ\s+|(POPRZEDNI ROZDZIAŁ)?\s+POTOP\s+(NASTĘPNY ROZDZIAŁ)?|\s+\*\s+|\s+KONIEC\s*$')
  puts line
end
