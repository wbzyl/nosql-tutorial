# encoding: UTF-8

require 'yajl'

require 'date'
require 'pp'

require 'couchrest'

unless keywords = ARGV[0]
  puts "Usage: ruby save_jsons_stream_to_couchdb.rb DBNAME\n"
  exit(0)
end

dbname = ARGV.shift
db = CouchRest.database!("http://127.0.0.1:4000/#{dbname}")

ARGF.each do |json|
  # czasami w pobieranym strumieniu zapląta się pusty wiersz
  next if json.match(/^\s*$/)
  
  parser = Yajl::Parser.new(:pretty => true) 

  begin
    hash = parser.parse(json)
  rescue
    puts "This can't happen: JSON Parsing ERROR"
    pp hash
    next
  end

  hash['_id'] = hash['id_str']
  hash.delete('id')
  hash.delete('id_str')

  date = DateTime.parse(hash['created_at'])
  hash['year'] = date.year
  hash['month'] = date.month
  hash['day'] = date.day
  hash['hour'] = date.hour
  hash['minute'] = date.minute
  hash['second'] = date.second
  
  db.save_doc(hash)
end
