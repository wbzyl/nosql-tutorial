require 'string_case_pl' # https://github.com/apohllo/string_pl

require 'mongo'

collection = Mongo::Connection.new("localhost", 27017).db("poliqarp").collection("toks")

# puts coll.count

collection.find.each do |doc|
  # puts "#{doc.inspect}"
  doc["orth"].downcase!
  # puts "#{doc.inspect}"
  collection.save(doc, safe: true)
end
