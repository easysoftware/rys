require 'rails/generators'
require 'rails/generators/rails/plugin/plugin_generator'

module Rys
  class PluginBuilder < ::Rails::PluginBuilder

    def readme
      template 'README.md'
    end

    def lib
      super
      template 'lib/%name%/features.rb'
      template 'lib/%name%/hooks.rb'
    end

    def config
      super
      template 'config/locales/en.yml.tt'
    end

  end

  class PluginGenerator < ::Rails::Generators::PluginGenerator
    source_root File.expand_path('templates', __dir__)

    class_option :path, type: :string

    self.source_paths << source_root
    self.source_paths << Rails::Generators::PluginGenerator.source_root

    def initialize(*args)
      super

      if options[:path].present?
        path = options[:path]
        @destination_root_by = :path
      elsif ENV.has_key?('RYS_PLUGINS_PATH')
        path = ENV['RYS_PLUGINS_PATH']
        @destination_root_by = :env
      else
        path = Rails.root.join('rys_plugins').to_s
        FileUtils.mkdir_p(path)
        @destination_root_by = :in_root
      end

      if !Dir.exist?(path)
        raise NameError, "Path '#{path}' does not exist."
      end

      self.destination_root = path
    end

    def mountable?
      false
    end

    def full?
      true
    end

    def with_dummy_app?
      false
    end

    def get_builder_class
      PluginBuilder
    end

    def create_root_files
      build(:readme)
      build(:rakefile)
      build(:gemspec)
      build(:gitignore) unless options[:skip_git]
      build(:gemfile)   unless options[:skip_gemfile]

      build(:bin, true)
      directory 'db'
    end

    def create_patches
      directory 'patches'
    end

    def create_test_files
      directory 'spec'
    end

    def create_view_example
      template 'app/views/issues/%name%/_view_issues_show_details_bottom.html.erb'
    end

    def append_to_gemfile
      return if options[:skip_git]

      gemfile_local = Rails.root.join('Gemfile.local')

      if !gemfile_local.exist?
        create_file gemfile_local
      end

      case @destination_root_by
      when :path
        path = "'#{destination_root}'"
      when :env
        path = "ENV['RYS_PLUGINS_PATH'] + '/#{app_path}'"
      when :in_root
        path = "'rys_plugins/#{app_path}'"
      end

      entry = "\ngem '#{name}', path: #{path}\n"
      append_file gemfile_local, entry
    end

    def init_git
      return if options[:skip_git]

      git :init
      git add: '.'
    end

    def informations
      shell.say
      shell.say_status 'created in', destination_root
    end

  end
end
