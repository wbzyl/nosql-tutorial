# encoding: UTF-8

require 'yajl/version' # dziwne?
require 'yajl/http_stream'

require 'pp'

unless keywords = ARGV[0]
  puts "\nUsage: ruby jsons_stream_to_couchdb_bulk_save.rb FILE"
  puts "\teach line in FILE should contain a complete json"
  puts "\tsprawdzamy czy są tylko JSON-y\n"
  exit(0)
end

while json = gets
  parser = Yajl::Parser.new(:pretty => true, :symbolize_keys => true)

  begin
    hash = parser.parse(json)
  rescue
    pp hash
    next
  end

end
