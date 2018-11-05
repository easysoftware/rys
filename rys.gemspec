$:.push File.expand_path('lib', __dir__)

require 'rys/version'

Gem::Specification.new do |s|
  s.name     = 'rys'
  s.version  = Rys::VERSION
  s.authors  = ['Easy Software']
  s.email    = ['info@easysoftware.com']
  s.homepage = 'https://www.easysoftware.com'
  s.summary  = 'Feature toggler, patch manager, plugin generator'
  s.license  = 'GNU/GPL 2'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*', 'spec/**/*']

  # s.files = `git ls-files -z`.split("\x0")
  # s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'request_store'
  s.add_dependency 'tty-prompt'
  s.add_dependency 'redmine_extensions"'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'pry-rails'
end
