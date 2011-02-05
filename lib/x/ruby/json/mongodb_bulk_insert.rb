require 'yajl'

json = File.new('mongodb.json', 'r')
parser = Yajl::Parser.new(:pretty => true, :symbolize_keys => true)
hash = parser.parse(json)

puts Yajl::Encoder.encode(hash[:results])
