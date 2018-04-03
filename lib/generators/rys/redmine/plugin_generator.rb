require 'rails/generators/named_base'

module Rys
  module Generators
    module Redmine
      class PluginGenerator < ::Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)

        def generate_redmine_plugin
          target_dir = Rails.root.join('plugins', name)

          if target_dir.directory?
            error 'Plugin generating failed'
            error "Directory '#{target_dir}' exist"
            exit 1
          end

          gems_target_dir = target_dir.join('gems')
          local_target_dir = target_dir.join('local')

          empty_directory target_dir
          empty_directory gems_target_dir
          empty_directory local_target_dir

          create_file gems_target_dir.join('.keep')
          create_file local_target_dir.join('.keep')

          if gems_rb?
            template 'gems.rb', target_dir.join('gems.rb')
          else
            template 'gems.rb', target_dir.join('Gemfile')
          end

          template '.gitignore', target_dir.join('.gitignore')
        end

        private

          def gems_rb?
            Rails.root.join('gems.rb').exist?
          end

      end
    end
  end
end
