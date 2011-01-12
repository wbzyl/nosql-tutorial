require 'test/unit'
require 'contacts_g'

Dir.mkdir("gdbm_contacts") unless File.exist?("gdbm_contacts")

class GDBMTest < Test::Unit::TestCase
  
  def setup
    @list = ContactList.new("gdbm_contacts")
    @contact = Contact.new("Joe Smith")
    
    @list << @contact
    
    @contact.home["street1"] = "123 Main Street"
    @contact.home["city"] = "Somewhere"
    @contact.work["phone"] = "(000) 123-4567"
    @contact.extras["instrument"] = "Cello"
    @contact.email = "joe@somewhere.abc"
  end
  
  def teardown
    @list.delete("Joe Smith") if @list["Joe Smith"]
  end

  def test_retrieving_a_contact_from_list
    contact = @list["Joe Smith"]
    assert_equal("Joe Smith", contact.name)
  end
  
  def test_delete_a_contact_from_list
    assert(!@list.empty?)
    @list.delete("Joe Smith")
    assert(@list.empty?)
    assert(@list.contact_cache.empty?)
  end
  
  def test_home
    contact = @list["Joe Smith"]
    assert_equal("123 Main Street", contact.home["street1"])
  end
  
  def test_email
    contact = @list["Joe Smith"]
    assert_equal("joe@somewhere.abc", contact.email)
  end
  
  def test_non_existent_contact_is_nil
    assert_equal(nil, @list["Some Person"])
  end
  
end
