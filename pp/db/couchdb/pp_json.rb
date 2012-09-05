#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'yajl/version' # dziwne?
require 'yajl/http_stream'

require 'pp'

if ARGV[0] == "-h"
  puts "Usage: ruby pp_json.rb"
  puts "Reads jsons from STDIN (each line should contain a complete json)."
  exit(0)
end

while json = gets
  parser = Yajl::Parser.new(:pretty => true, :symbolize_keys => true)

  begin
    pp parser.parse(json)
    pp "-"*44
  rescue
    $stderr.puts 'Damaged JSON. Skipped'
    next
  end

end
