require 'gdbm'
require 'fileutils'

class ContactList

  attr_reader :contact_cache

  def initialize(dir)
    @dir = dir
    @contact_cache = []
  end
  
  def [](name)
    contact = @contact_cache.find {|c| c.name == name }
    return contact if contact
    contact = Contact.new(name)
    Dir.chdir(@dir) do
      if File.directory?(contact.dirname)
        populate_contact(contact)
        @contact_cache << contact
      else
        contact = nil
      end
    end
    contact
  end
  
  def populate_contact(contact)
    Dir.chdir(contact.dirname) do
      contact.open
    end
  end
  
  def <<(contact)
    Dir.chdir(@dir) do
      Dir.mkdir(contact.dirname) unless File.exists?(contact.dirname)
      populate_contact(contact)
    end
    @contact_cache << contact
  end
  
  def delete(name)
    contact = self[name]
    return false unless contact
    contact.close
    Dir.chdir(@dir) do
      FileUtils.rm_rf(contact.dirname)
    end
    contact_cache.delete_if {|c| c.name == name }
    true
  end
  
  def directory_names
    Dir["#{@dir}/*"]
  end
  
  def size
    directory_names.size
  end
  
  def empty?
    directory_names.empty?
  end
  
end


class Contact

  COMPONENTS = ["home", "extras", "work"]

  attr_accessor :name, *COMPONENTS

  attr_reader :dirname

  def initialize(name)
    @name = name
    @dirname = @name.gsub(" ", "_")
  end

  def components
    COMPONENTS.map {|comp_name| self.send(comp_name) }
  end
  
  def open
    COMPONENTS.each do |component|
      self.send(component + "=", GDBM.new(component))
    end
  end
  
  def close
    components.each do |component|
      component.close unless component.closed?
    end
  end

  def email
    extras["email"]
  end
  
  def email=(e)
    extras["email"] = e
  end
 
end
