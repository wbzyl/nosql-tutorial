# -*- coding: utf-8 -*-

require 'bookmark'

view_all = {
  :map => "function(doc) { if (doc['couchrest-type'] == 'Bookmark') emit(doc._id, doc); }"
}

DB.delete_doc(DB.get("_design/bookmarks")) rescue nil

DB.save_doc  "_id" => "_design/bookmarks", :views => { :all => view_all }

puts DB.view("bookmarks/all")['rows'].inspect
