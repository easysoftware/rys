require_relative 'base'

module Rys
  module Generators
    module Rspec
      class ControllerGenerator < Base

        argument :actions, type: :array, default: [], banner: '*[action]'
        class_option :controller_specs, type: :boolean, default: true
        class_option :view_specs, type: :boolean, default: true

        def generate_controller_spec
          return unless options[:controller_specs]

          target_file = File.join('spec/controllers', class_path, "#{file_name}_controller_spec.rb")
          template 'controller_spec.rb', target_file
        end

        def generate_view_specs
          return if actions.empty?
          return unless options[:view_specs]

          empty_directory File.join('spec/views', file_path)

          actions.each do |action|
            # @action = action
            target_file = File.join('spec/views', file_path, "#{action}.html.erb_spec.rb")
            template 'view_spec.rb', target_file
          end
        end

      end
    end
  end
end
