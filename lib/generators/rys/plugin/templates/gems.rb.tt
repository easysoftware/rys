source 'https://rubygems.org'

gemspec

# There are defined commands, after install hook and custom hooks
plugin 'rys-bundler', github: 'easysoftware/rys-bundler', branch: 'master'

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
