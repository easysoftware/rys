source 'https://rubygems.org'
git_source(:easy_git){ |name| "git@git.easy.cz:platform-2.0/#{name}.git" }

gemspec


# This section can be loaded into main Application
#
group :rys do
  group :default do
    gem 'rys', easy_git: 'rys', branch: 'master'
    gem 'easy_core', easy_git: 'easy_core', branch: 'master'
  end

  # group :development do
  # end

  # group :test do
  # end
end


# This section is for developing inside gem
#
local_gemfile = File.join(__dir__, 'spec/dummy/Gemfile')

if File.exists?(local_gemfile)
  eval_gemfile(local_gemfile)
else
  puts 'Missing dummy Easy Redmine'
end
