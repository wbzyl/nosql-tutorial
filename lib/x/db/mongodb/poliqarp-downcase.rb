require 'string_case_pl' # https://github.com/apohllo/string_pl

require 'mongo'

connection = Mongo::Connection.new("localhost", 27017, safe: true) # safe propagated to DB objects
database = Mongo::DB.new("poliqarp", connection, strict: true)     # collections must exist to be accessed

# collection = Mongo::Connection.new("localhost", 27017, safe: true).db("poliqarp").collection("toks")

collection = Mongo::Collection.new("toks", database)

puts "Documents in collection: #{collection.count}"
puts "safe mode: #{collection.safe}"

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
