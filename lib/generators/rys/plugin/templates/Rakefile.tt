require 'bundler/setup'

possible_app_dirs = [
  ENV['DUMMY_PATH'],
  File.join(Dir.pwd, 'test/dummy')
]
dir = possible_app_dirs.compact.first

if !File.directory?(dir)
  abort("Directory '#{dir}' does not exists")
end

APP_RAKEFILE = File.expand_path(File.join(dir, 'Rakefile'), __dir__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks
