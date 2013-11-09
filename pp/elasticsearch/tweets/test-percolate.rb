require "bundler/setup"

require "elasticsearch"

client = Elasticsearch::Client.new log: true

result = client.percolate index: 'tweets', body: {
  doc: { text: "MongoDB + Elasticsearch = Love" } }
# result:
# {
#   "ok"=>true,
#   "matches"=>["mongodb", "elasticsearch"]
# }

if (result["ok"] == true) && (result["matches"].any?)
  puts result["matches"]
  puts "SAVE tweet"
end
