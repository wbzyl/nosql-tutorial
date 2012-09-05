# -*- coding: utf-8 -*-
#
# 1. zakładamy bazę:
#     createdb test
# 2. uruchamiamy ten skrypt:
#     ruby 010-postgres.rb
# 3. przyłączamy się do bazy:
#     psql test
#     \d
#     \encoding  # powinno być UTF8
#     \q

require 'rubygems'
require 'dm-core'

# http://cheat.errtheblog.com/s/datamapper/
# DataMapper.setup(:default, "adapter://user:password@hostname/dbname")

# sudo gem install dm-imap-adapter
# sudo gem install dm-yaml-adapter

# http://datamapper.rubyforge.org/dm-core/DataMapper.html
#
# DataMapper.setup(:default, {
#   :adapter  => 'adapter_name_here',
#   :database => "path/to/repo",
#   :username => 'username',
#   :password => 'password',
#   :host     => 'hostname'
# })

# :fatal, :error, :warn, :info, :debug 

log = DataMapper::Logger.new(STDOUT, :debug)

log.push "==== hello datamapper"

DataMapper.setup(:default,'postgres:test')

class Post
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :body,       Text
  property :created_at, DateTime

  has n, :comments
end

class Comment
  include DataMapper::Resource

  property :id,         Serial
  property :posted_by,  String
  property :email,      String
  property :url,        String
  property :body,       Text

  belongs_to :post
end

class Category
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
end

class Categorization
  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime

  belongs_to :category
  belongs_to :post
end

class Post
  has n, :categorizations
  has n, :categories, :through => :categorizations
end

class Category
  has n, :categorizations
  has n, :posts, :through => :categorizations
end

# Post.auto_migrate!
# Category.auto_migrate!
# Comment.auto_migrate!
# Categorization.auto_migrate!

DataMapper.auto_migrate!
