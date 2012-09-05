require 'rubygems'
require 'dm-core'

DataMapper.setup(:default,'sqlite3:test.sqlite3')

log = DataMapper::Logger.new(STDOUT, :debug)

log.push "==== hello datamapper"

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
