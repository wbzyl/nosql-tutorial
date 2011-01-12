# -*- coding: utf-8 -*-

require 'rubygems'
require 'restclient'
require 'json'

post01 = {
  "type"    => "post",
  "author"  => "jacek",
  "title"   => "Rails 2",
  "content" => "Bla bla…"
}

comment11 = {
  "type"    => "comment",
  "post"    => "01",
  "author"  => "agatka",
  "content" => "…"
}
comment12 = {
  "type"    => "comment",
  "post"    => "01",
  "author"  => "bolek",
  "content" => "…"
}

post02 = {
  "type"    => "post",
  "author"  => "jacek",
  "title"   => "Rails 3",
  "content" => "Bla bla bla…"
}

comment13 = {
  "type"    => "comment",
  "post"    => "02",
  "author"  => "lolek",
  "content" => "…"
}

comment14 = {
  "type"    => "comment",
  "post"    => "02",
  "author"  => "bolek",
  "content" => "…"
}

post03 = {
  "type"    => "post",
  "author"  => "agatka",
  "title"   => "Sinatra 1.0",
  "content" => "Bla…"
}

comment15 = {
  "type"    => "comment",
  "post"    => "03",
  "author"  => "jacek",
  "content" => "…"
}

comment16 = {
  "type"    => "comment",
  "post"    => "03",
  "author"  => "lolek",
  "content" => "…"
}

comment17 = {
  "type"    => "comment",
  "post"    => "03",
  "author"  => "bolek",
  "content" => "…"
}

DB="http://127.0.0.1:5984/blog-separate"

RestClient.delete DB rescue nil

RestClient.put "#{DB}", ""

RestClient.put "#{DB}/01", post01.to_json
RestClient.put "#{DB}/02", post02.to_json
RestClient.put "#{DB}/03", post03.to_json

RestClient.put "#{DB}/11", comment11.to_json
RestClient.put "#{DB}/12", comment12.to_json
RestClient.put "#{DB}/13", comment13.to_json
RestClient.put "#{DB}/14", comment14.to_json
RestClient.put "#{DB}/15", comment15.to_json
RestClient.put "#{DB}/16", comment16.to_json
RestClient.put "#{DB}/17", comment17.to_json
