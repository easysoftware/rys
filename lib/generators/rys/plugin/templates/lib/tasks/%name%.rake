require 'rspec/core/rake_task'

namespace :<%= name %> do

  desc 'Runs rspec tests'
  RSpec::Core::RakeTask.new(:spec) do |task, task_args|
    task.pattern = <%= camelized %>::Engine.root.join('spec/**/*_spec.rb')
  end

end
