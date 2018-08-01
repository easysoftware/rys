# Dependencies which are loaded in main application or in dummy application
# All gems must be in "rys" group

git_source(:github) {|name| "https://github.com/#{name}.git" }
git_source(:easy) {|name| "git@git.easy.cz:#{name}.git" }

group :rys do
  group :default do
    gem 'rys', github: 'easysoftware/rys', branch: 'master'
    gem 'ryspec', github: 'easysoftware/ryspec', branch: 'master'
  end

  group :development do
  end

  group :test do
  end
end
