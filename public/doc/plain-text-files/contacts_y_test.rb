require "test/unit"
require "contacts_y"

class TestContacts < Test::Unit::TestCase
  
  def setup
    @filename = "contacts.yaml"
    @list = ContactList.new(@filename)
    @contact = Contact.new("Joe Smith")
    
    @contact.email = "joe@somewhere.abc"
    @contact.home[:street1] = "123 Main Street"
    @contact.home[:city] = "Somewhere"
    @contact.work[:phone] = "(000) 123-4567"
    @contact.extras[:instrument] = "Cello"
    
    @list << @contact
  end

  def test_retrieve_contact_from_list
    contact = @list["Joe Smith"]
    assert_equal("Joe Smith", contact.name)
  end

  def test_delete_contact_from_list
    assert(!@list.empty?)
    @list.delete(@contact.name)
    assert(@list.empty?)
  end
  
  def test_save_and_load_list
    @list.save
    relist = ContactList.load(@filename)
    assert_equal(1, relist.size)
    contact = relist["Joe Smith"]
    assert_equal("Joe Smith", contact.name)
  end
  
end
