require 'bundler'

spec = Bundler.load.specs.find{|s| s.name.to_s == 'ryspec' }

if !spec
  abort('Gem ryspec was not found. Please add it and run bundle install again.')
end

require File.join(spec.full_gem_path, 'spec/spec_helper')
