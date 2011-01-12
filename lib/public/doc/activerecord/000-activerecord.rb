# run with:
#
#    clear && spec -c -f specdoc 000-activerecord.rb 

require 'rubygems'
require 'spec'
require 'active_record'

require 'activerecord_spec_helper'

#ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
#ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'test.sqlite3')

class CreateStuff < ActiveRecord::Migration
  def self.up
    create_table :dogs do |t|
      t.string :name, :null => false
    end
    create_table :toys do |t|
      t.string :name, :null => false
    end
    create_table :dog_toys do |t|
      t.integer :dog_id, :null => false
      t.integer :toy_id, :null => false      
    end
  end

  def self.down
  end
end

CreateStuff.migrate :up

class Dog < ActiveRecord::Base
  validates_presence_of   :name
  validates_uniqueness_of :name  

  has_many :dog_toys
  has_many :toys, :through => :dog_toys
end

class DogToy < ActiveRecord::Base
  belongs_to :dog
  belongs_to :toy
end

class Toy < ActiveRecord::Base
  has_many :dog_toys
  has_many :dogs, :through => :dog_toys
end

describe Dog do

  it 'requires a name' do
    Dog.create(:name => nil    ).should_not be_valid
    Dog.create(:name => ''     ).should_not be_valid
    Dog.create(:name => 'Rover').should     be_valid
  end

  it 'requires unique name' do
    Dog.create(:name => 'Rover').should     be_valid
    Dog.create(:name => 'Rover').should_not be_valid
    Dog.create(:name => 'Spot' ).should     be_valid
  end

  it 'has many toys' do
    rover = Dog.create(:name => 'Rover')
    rover.toys.should be_empty

    rover.toys.create :name => 'Squeeky Toy'
    rover.toys.length.should == 1
    rover.toys.first.name.should == 'Squeeky Toy'
  end
  
end 
