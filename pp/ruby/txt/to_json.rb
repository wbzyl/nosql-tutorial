#! /usr/bin/env ruby

# Usage:
#   bunzip2 -c groceries.txt.bz2 | ./to_json.rb

require 'mongo'

def process_line(s, lineno)
  puts lineno
  p s.rstrip.split(',')
end

ARGF.each_line { |line| process_line(line, ARGF.lineno) }
