# file: collseq.rb
require 'rubygems'
require 'restclient'
require 'json'

DB="http://127.0.0.1:5984/collator"
RestClient.delete DB rescue nil
RestClient.put "#{DB}",""
(32..126).each do |c|
  RestClient.put "#{DB}/#{c.to_s(16)}", {"x"=>c.chr}.to_json
end
RestClient.put "#{DB}/_design/test", <<EOS
{
  "views":{
    "one":{
      "map":"function (doc) { emit(doc.x,null); }"
    }
  }
}
EOS
puts RestClient.get("#{DB}/_design/test/_view/one")

