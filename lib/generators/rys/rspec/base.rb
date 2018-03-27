require 'rails/generators/named_base'

module Rys
  module Generators
    module Rspec
      class Base < ::Rails::Generators::NamedBase

        def self.source_root(path=nil)
          @_source_root = path if path
          @_source_root ||= File.expand_path('templates', __dir__)
        end

      end
    end
  end
end
