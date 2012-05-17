require 'string_case_pl' # https://github.com/apohllo/string_pl

require 'mongo'

# collection = Mongo::Connection.new("localhost", 27017).db("test").collection("students")

collection = Mongo::Connection.new("localhost", 27017).db("poliqarp").collection("toks")

puts "Documents in collection: #{coll.count}"

# Cursors
#
# http://www.mongodb.org/display/DOCS/How+to+do+Snapshotted+Queries+in+the+Mongo+Database
# http://api.mongodb.org/ruby/current/Mongo/Cursor.html

cursor = Mongo::Cursor.new(collection, snapshot: true)

# puts cursor.class
# puts cursor.full_collection_name
# puts cursor.snapshot

# collection.find.each do |doc|
cursor.each do |doc|
  # puts "#{doc.inspect}"
  doc["orth"].downcase!
  # puts "#{doc.inspect}"
  collection.save(doc, safe: true)
end
