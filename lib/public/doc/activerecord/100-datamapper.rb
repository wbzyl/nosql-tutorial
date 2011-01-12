# -*- coding: utf-8 -*-
# run with:
#
#    clear && spec -c -f specdoc 100-datamapper.rb 

require 'rubygems'
require 'spec'
require 'dm-core'
require 'dm-validations'

require 'datamapper_spec_helper'

#DataMapper::Logger.new(STDOUT, :debug)

class Dog
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :required => true, :unique => true

  has n, :toys, :through => Resource
end

class Toy
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :required => true, :unique => true
end

DataMapper.setup :default, 'sqlite3::memory:'
#DataMapper.setup :default, 'sqlite3:test.sqlite3'


DataMapper.auto_migrate!

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
