ENV['RAILS_ENV'] ||= 'test'

require 'pry-rails'

# require File.expand_path('./config/environment')
# require Rails.root.join('./config/environment')
require File.expand_path('../dummy/config/environment.rb', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'easy_extensions/spec_helper'
