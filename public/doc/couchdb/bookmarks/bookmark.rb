# -*- coding: utf-8 -*-

require 'rubygems'
require 'restclient'
require 'couchrest'

# jeśli bazy nie ma, to zostanie utworzona
# jeśli baza już jest, to nic nie rób
DB = CouchRest.database!("http://wbzyl:sekret@localhost:5984/bookmarks")

class Bookmark < CouchRest::ExtendedDocument
  use_database DB

  property :url
  property :title
  property :tags, :cast_as => ['String']

  view_by :url
  view_by :title, :descending => true
  
  view_by :tags,
    :map => "function(doc) {
            if (doc['couchrest-type'] == 'Bookmark' && doc.tags) {
              doc.tags.forEach(function(tag){
                emit(tag, 1);
              });
            }}",
    :reduce => "function(keys, values, rereduce) {
                  return sum(values);
               }"
  
  timestamps!
end
