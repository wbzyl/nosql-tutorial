# -*- coding: utf-8 -*-

require 'rubygems'
require 'restclient'
require 'json'

post1 = {
  "author"  => "jacek",
  "title"   => "Rails 2",
  "content" => "Bla bla…",
   "comments" => [
    {"author" => "agatka", "content" => "…"},
    {"author" => "bolek",  "content" => "…"}
  ]
}

post2 = {
  "author"  => "jacek",
  "title"   => "Rails 3",
  "content" => "Bla bla bla…",
   "comments" => [
    {"author" => "lolek", "content" => "…"},
    {"author" => "bolek", "content" => "…"}
  ]
}

post3 = {
  "author"  => "agatka",
  "title"   => "Sinatra 1.0",
  "content" => "Bla…",
  "comments" => [
    {"author" => "jacek", "content" => "…"},
    {"author" => "lolek", "content" => "…"},
    {"author" => "bolek", "content" => "…"}
  ]
}

DB="http://127.0.0.1:5984/blog-inline"

RestClient.delete DB rescue nil

RestClient.put "#{DB}", ""

RestClient.put "#{DB}/01", post1.to_json
RestClient.put "#{DB}/02", post2.to_json
RestClient.put "#{DB}/03", post3.to_json

__END__

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
