source 'https://rubygems.org'

gemspec

local_gemfile = File.join(__dir__, 'spec/dummy/Gemfile')

if File.exists?(local_gemfile)
  eval_gemfile(local_gemfile)
else
  puts 'Missing dummy Redmine'
end
