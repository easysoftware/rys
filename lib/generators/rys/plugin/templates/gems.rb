source 'https://rubygems.org'
git_source(:easy_git){ |name| "git@git.easy.cz:platform-2.0/#{name}.git" }

gemspec

# There are defined commands, after install hook and custom hooks
plugin 'rys-bundler', easy_git: 'rys-bundler', branch: 'master'

# Common dependencies
eval_gemfile('dependencies.rb')

# Loading gems dependecies in right moment
Plugin.hook('rys-gemfile', self)

# Loading gems from dummy application
# Possible paths (by priority)
#   1. As second argument
#   2. Environment variable DUMMY_PATH
#   3. Current_dir / test / dummy
Plugin.hook('rys-load-dummy', self)
