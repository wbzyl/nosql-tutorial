#! /bin/env ruby
#-*- coding: utf-8 -*-

lines = File.read("potop.txt").split("\n").push("")

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
      #puts "[2 -> 2]"
      state = 2
    else
      #puts "[2 -> 1]"
      puts "\n#{line}"
      state = 1
    end

  end

end
