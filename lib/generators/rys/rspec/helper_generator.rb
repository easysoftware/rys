require_relative 'base'

module Rys
  module Generators
    module Rspec
      class HelperGenerator < Base

        class_option :helper_specs, type: :boolean, default: true

        def generate_helper_spec
          return unless options[:helper_specs]

          target_file = File.join('spec/controllers', class_path, "#{file_name}_helper_spec.rb")
          template 'helper_spec.rb', target_file
        end

      end
    end
  end
end
