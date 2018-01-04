require 'rails/generators'
require 'rails/generators/rails/plugin/plugin_generator'

module Easy
  class PluginBuilder < ::Rails::PluginBuilder

    def lib
      super
      template "lib/%name%/features.rb"
      template "lib/%name%/hooks.rb"
    end

  end

  class EngineGenerator < ::Rails::Generators::PluginGenerator
    source_root File.expand_path('../templates', __FILE__)

    self.source_paths << source_root
    self.source_paths << Rails::Generators::PluginGenerator.source_root

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

    def create_bin_files
      nil
    end

    def create_patches_example
      directory 'patches'
    end

    def create_root_files
      # build(:readme)
      build(:rakefile)
      build(:gemspec)   unless options[:skip_gemspec]
      # build(:license)
      build(:gitignore) unless options[:skip_git]
      build(:gemfile)   unless options[:skip_gemfile]
    end

    def create_test_files
      directory 'spec'
    end

    def create_view_example
      template 'app/views/issues/_view_issues_show_details_bottom.html.erb'
    end

  end
end
