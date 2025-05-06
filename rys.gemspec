# encoding: utf-8

$:.push File.expand_path('lib', __dir__)
require 'rys/version'

Gem::Specification.new do |s|
  s.name     = 'rys'
  s.version  = Rys::VERSION
  s.authors  = ['Easy Software']
  s.email    = ['info@easysoftware.com']
  s.homepage = 'https://www.easysoftware.com'
  s.summary  = 'Feature toggler, patch manager, plugin generator'
  s.license  = 'GPL-2.0-or-later'

  s.metadata['allowed_push_host'] = 'https://gems.easysoftware.com'

  s.files = Dir['{app,config,db,lib,patches}/**/{*,.*}', 'Rakefile', 'README.md', 'gems.rb', '.rubocop.yml']
  s.test_files = Dir['spec/**/*', 'test/.keep']

  s.add_dependency 'rails', '~> 7.0'
end
