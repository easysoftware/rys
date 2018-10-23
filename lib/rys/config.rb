module Rys
  ##
  # Rys::Config
  #
  # Manage rys configuration
  #
  # @example
  #   config = Config.from_dsl {
  #     name 'Lynx'
  #     description 'First', 'Second'
  #     amazing!
  #   }
  #   config.name
  #   # => 'Lynx'
  #
  #   config.description
  #   # => ['First', 'Second']
  #
  #   config.amazing
  #   # => true
  #
  #   config.undefined_key
  #   # => nil
  #
  class Config < OpenStruct

    class Dsl

      attr_reader :table

      def initialize
        @table = {}
      end

      def method_missing(name, *args, &block)
        name = name.to_s

        if name.end_with?('!')
          @table[name.slice(0..-2)] = true
        elsif args.size == 1
          @table[name] = args.first
        elsif args.size > 1
          @table[name] = args
        else
          super
        end

        self
      end

    end

    def self.from_dsl(&block)
      new Dsl.new.instance_eval(&block).table
    end

  end
end
