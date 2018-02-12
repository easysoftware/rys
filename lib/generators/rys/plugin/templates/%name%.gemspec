$:.push File.expand_path('lib', __dir__)

require '<%= name %>/version'

Gem::Specification.new do |s|
  s.name        = '<%= name %>'
  s.version     = <%= camelized %>::VERSION
  s.authors     = ['<%= author %>']
  s.email       = ['<%= email %>']
  s.homepage    = 'https://easysoftware.com'
  s.summary     = 'Summary of <%= camelized %>.'
  s.description = 'Description of <%= camelized %>.'
  s.license     = 'GNU/GPL 2'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*', 'spec/**/*']

  s.add_dependency 'rys'
  s.add_development_dependency 'pry-rails', '~>0.3.6'
end
