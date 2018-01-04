$:.push File.expand_path('../lib', __FILE__)

require 'easy/version'

Gem::Specification.new do |s|
  s.name     = 'easy_core'
  s.version  = Easy::VERSION
  s.authors  = ['Easy Software']
  s.email    = ['info@easysoftware.com']
  s.homepage = 'https://www.easysoftware.com'
  s.summary  = 'Easy Core plugin'
  s.license  = 'GNU/GPL 2'

  s.files = `git ls-files -z`.split("\x0")
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency('rails', '4.2.8')
  s.add_development_dependency('rspec-rails', '~> 3.6')
  s.add_development_dependency('factory_bot_rails', '~> 4.8.2')
  s.add_development_dependency('database_cleaner', '~> 1.6.2')
  s.add_development_dependency('faker', '~> 1.8.4')
  s.add_development_dependency('pry-rails', '~> 0.3.6')
  # s.add_development_dependency('capybara', '~> 2')
  # s.add_development_dependency('selenium-webdriver')
  # s.add_development_dependency 'sqlite3'
  # s.add_development_dependency 'sass-rails', '~> 5.0.7'

end
