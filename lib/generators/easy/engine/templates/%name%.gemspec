$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "<%= name %>/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "<%= name %>"
  s.version     = <%= camelized_modules %>::VERSION
  s.authors     = ["<%= author %>"]
  s.email       = ["<%= email %>"]
  s.homepage    = "https://easysoftware.com"
  s.summary     = "TODO: Summary of <%= camelized_modules %>."
  s.description = "TODO: Description of <%= camelized_modules %>."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "easy_software", "> 0"
end
