$:.push File.expand_path('../lib', __dir__)
ENV['RAILS_ENV'] ||= 'test'

require File.join(__dir__, 'dummy/config/environment')
require 'rspec/rails'

RSpec.configure do |config|

  # Enables zero monkey patching mode for RSpec.
  config.disable_monkey_patching!

  # Sets the expectation framework module(s) to be included in each example group.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Sets the mock framework adapter module.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Configures how RSpec treats metadata passed as part of a shared example group definition.
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
