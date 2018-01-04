# require 'capybara/rspec'
require 'rspec/rails'
require 'pry-rails'
require 'faker'
require 'factory_bot_rails'
require 'database_cleaner'
require 'sass-rails'
require 'authlogic/test_case'

Dir.glob(File.expand_path('../support/*.rb', __FILE__)).each do |file|
  require file
end

ActiveRecord::Migration.maintain_test_schema!

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata))
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before(:each) do |ex|
    meta = ex.metadata
    unless meta[:null]
      logged_user case meta[:logged]
                  when :admin
                    FactoryGirl.create(:admin_user, language: 'en')
                  when true
                    FactoryGirl.create(:user, language: 'en')
                  else
                    User.anonymous
                  end
    end
  end

end
