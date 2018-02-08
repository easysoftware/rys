#!/usr/bin/env ruby
require "yaml"
require "securerandom"
require "optparse"

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: tester.rb [options]"

  options[:dummy_git] = 'git@git.easy.cz:easyredmine/stable-2016.git'
  opts.on( '-g', '--dummy_git GIT_URL', 'Git repository with dummy (Easy )Redmine to clone', :REQUIRED ) do |arg|
    options[:dummy_git] = arg
  end
  options[:branch] = 'master'
  opts.on( '-b', '--branch BRANCH', 'Git branch with correct version of dummy',  ) do |arg|
    options[:branch] = arg
  end
  options[:adapter] = 'mysql2'
  opts.on( '-a', '--adapter NAME', 'Database adapter to used with dummy. Possibles are: `mysql2` or `postgresql`', :REQUIRED ) do |arg|
    options[:adapter] = arg
  end
end
optparse.parse!

def prepare_dummy(options)
  system %Q{git clone -b #{options[:branch]} #{options[:dummy_git]} test/dummy >/dev/null  }
  create_env
  create_database_yml(options)
  prepare_schema
end

def create_env
  plugin_name = File.basename(Dir["*"].find { |i| i.end_with?("gemspec") }, '.gemspec')
  File.open("./test/dummy/config/additional_environment.rb", "w") do |f|
    f.write <<EOF
begin
  require '#{plugin_name}'
rescue Exception
  puts "Skip require '#{plugin_name}'"
end
EOF
  end
end

def create_database_yml(options)
  case (adapter = options[:adapter])
  when nil, 'mysql2'
    username, pwd = 'root', "<%= ENV['MYSQL_PASS'] %>"
  when 'postgresql'
    username, pwd = 'postgres', ""
  else
    raise ArgumentError, "#{adapter} adapter is not allowed!"
  end
  source = {
      "test" => {
          "adapter" => adapter || 'mysql2',
          "database" => SecureRandom.hex(16).to_s,
          "host" => "localhost",
          "username" => username,
          "password" => pwd
      }
  }
  # source["test"] = source["development"]
  File.open("./test/dummy/config/database.yml", "w") { |f| f.write source.to_yaml }
end

def prepare_schema
  system %q{$SHELL -c "export RAILS_ENV=test; cd test/dummy && bundle install --without xapian rmagick && bundle exec rake db:drop db:create && ruby prepare_schema.rb" 1>/dev/null 2>&1}
end

prepare_dummy(options)
