require 'rails/generators'
require 'rails/generators/rails/plugin/plugin_generator'

module Rys
  class PluginBuilder < ::Rails::PluginBuilder

    def readme
      template "README.md"
    end

    def lib
      super
      template 'lib/%name%/features.rb'
      template 'lib/%name%/hooks.rb'
    end

  end

  class PluginGenerator < ::Rails::Generators::PluginGenerator
    source_root File.expand_path('templates', __dir__)

    self.source_paths << source_root
    self.source_paths << Rails::Generators::PluginGenerator.source_root

    def initialize(*args)
      super

      self.destination_root = Rails.root.join('rys_plugins').to_s
      FileUtils.mkdir_p(destination_root)
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

      entry = "gem '#{name}', path: 'rys_plugins/#{camelized}'"
      # append_file gemfile_local, entry
    end

    def init_git
      return if options[:skip_git]

      git :init
      git add: '.'
    end

  end
end
