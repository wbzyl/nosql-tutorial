#! /bin/env ruby
#-*- coding: utf-8 -*-

# File.readlines("potop.txt").each do |line|
#   next if line.match('--------|ROZDZIAŁ\s+|(POPRZEDNI ROZDZIAŁ)?\s+POTOP\s+(NASTĘPNY ROZDZIAŁ)?|\s+\*\s+|\s+KONIEC\s*$')
#   puts line
# end

lines = File.read("pan_tadeusz.txt").split("\n").push("")

state = 1

lines.each do |line|

  case state

  when 1
    if line.empty?
      #puts "[1 -> 2]"
      state = 2
    else
      #puts "[1 -> 1]"
      puts "#{line}"
      state = 1
    end

  when 2
    if line.empty?
      #puts "[2 -> 3]"
      state = 3
    else
      #puts "[2 -> 2]"
      puts "#{line}"
      state = 1
    end

  when 3
    if line.empty?
      #puts "[3 -> 3]"
       state = 3
    else
      #puts "[3 -> 1]"
      state = 1
      #puts "[3: \\par]"
      puts "\n#{line}"
    end

  end

end
