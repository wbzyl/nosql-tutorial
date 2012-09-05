# -*- coding: utf-8 -*-

require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'extlib'

Extlib::Inflection.plural_word 'film', 'filmy' 
Extlib::Inflection.plural_word 'recenzja', 'recenzje'
Extlib::Inflection.plural_word 'kino', 'kina'

Extlib::Inflection.plural_word 'sesja', 'sesje'
# bug:
#  jeśli nazwa modelu kończy się na 's', to
#  datamapper głupieje, np.:
# Extlib::Inflection.plural_word 'seans', 'seanse'

DataMapper.setup :default, 'sqlite3:ale-kino.sqlite3'

log = DataMapper::Logger.new(STDOUT, :debug)

#log.push "==== hello datamapper"

class Film
  include DataMapper::Resource
  property :id,             Serial
  property :name,           String
  property :minutes,        Integer
  property :average_stars,  Float  
  timestamps :at

  has n, :recenzja
  has n, :sesja
  has n, :kino, :through => :sesja
end

class Recenzja
  include DataMapper::Resource
  property :id,           Serial
  property :author_name,  String
  property :stars,        Integer
  property :content,      Text  
  timestamps :at

  belongs_to :film
end

class Kino
  include DataMapper::Resource
  property :id,    Serial
  property :name,  String
  timestamps :at

  has n, :sesja
  has n, :film, :through => :sesja
end

class Sesja
  include DataMapper::Resource
  property :id,         Serial
  property :starts_on,  Date
  property :ends_on,    Date  
  timestamps :at
  
  belongs_to :kino
  belongs_to :film
end

DataMapper.auto_migrate!
