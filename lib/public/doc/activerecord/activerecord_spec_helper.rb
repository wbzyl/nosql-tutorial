# ActiveRecord transactional specs (without Rails)
Spec::Runner.configure do |config|
  config.before do
    ActiveRecord::Base.connection.begin_db_transaction
    ActiveRecord::Base.connection.increment_open_transactions
  end
  config.after do
    if ActiveRecord::Base.connection.open_transactions != 0
      ActiveRecord::Base.connection.rollback_db_transaction
      ActiveRecord::Base.connection.decrement_open_transactions
    end
  end
end
