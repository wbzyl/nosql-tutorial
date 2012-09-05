require 'rubygems'
require 'dm-core'
require 'extlib'

DataMapper.setup :default, 'sqlite3:test.sqlite3'

Extlib::Inflection.plural_word 'xs', 'xse'

class Xs
#class Comment
  include DataMapper::Resource
  property :id,    Serial
  property :name,  String
  belongs_to :film
end

class Film
  include DataMapper::Resource
  property :id,    Serial
  property :name,  String
  has n, :xse
  #has n, :comments
end

DataMapper.auto_migrate!
