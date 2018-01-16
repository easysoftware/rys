$:.push File.expand_path('lib', __dir__)

require '<%= name %>/version'

Gem::Specification.new do |s|
  s.name        = '<%= name %>'
  s.version     = <%= camelized %>::VERSION
  s.authors     = ['<%= author %>']
  s.email       = ['<%= email %>']
  s.homepage    = 'https://easysoftware.com'
  s.summary     = 'TODO: Summary of <%= camelized %>.'
  s.description = 'TODO: Description of <%= camelized %>.'
  s.license     = 'GNU/GPL 2'

  s.files = Dir['{app,config,db,lib,spec}/**/*', 'Rakefile', 'README.md']

  s.add_dependency 'rys'
end
