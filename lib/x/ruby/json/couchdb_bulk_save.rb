require 'yajl'
require 'pp'

json = File.new('couchdb.json', 'r')
parser = Yajl::Parser.new(:pretty => true, :symbolize_keys => true)
hash = parser.parse(json)

##pp hash

hash_couchdb = {}
hash_couchdb[:docs] = hash[:results]

puts Yajl::Encoder.encode(hash_couchdb)
