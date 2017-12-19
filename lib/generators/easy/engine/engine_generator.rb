require 'rails/generators'
require 'rails/generators/rails/plugin/plugin_generator'

module Easy
  class PluginBuilder < ::Rails::PluginBuilder

    def gemfile_entry
      return unless inside_application?

      gemfile_in_app_path = File.join(rails_app_path, 'Gemfile.local')
      if File.exist?(gemfile_in_app_path)
        entry = "gem '#{name}', path: '#{relative_path}'"
        append_file gemfile_in_app_path, entry
      end
    end

  end

  class EngineGenerator < ::Rails::Generators::PluginGenerator
    source_root File.expand_path('../templates', __FILE__)

    self.source_paths << source_root
    self.source_paths << Rails::Generators::PluginGenerator.source_root

    def mountable?
      true
    end

    def with_dummy_app?
      false
    end

    def get_builder_class
      PluginBuilder
    end

    def create_extensions_example
      template "extensions/%namespaced_name%/issue.rb"
    end

  end
end
