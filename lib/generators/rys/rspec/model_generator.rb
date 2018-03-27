require_relative 'base'

module Rys
  module Generators
    module Rspec
      class ModelGenerator < Base

        argument :attributes,
                 type: :array,
                 default: [],
                 banner: '*[field:type]'

        def generate_model_spec
          target_file = File.join('spec/models', class_path, "#{file_name}_spec.rb")
          template 'model_spec.rb', target_file
        end

        hook_for :fixture_replacement

      end
    end
  end
end
