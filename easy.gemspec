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

  # s.add_dependency 'redmine_extensions', '~> 0.2.0'
  # s.add_development_dependency 'benchmark-ips'
end
