module Rys
  module RailsGenerator
    class Base < ::Rails::Generators::NamedBase

      def self.namespace
        "rys:#{origin_name}"
      end

      def self.help(shell)
        shell.say "Usage for Rys:"
        shell.say "  rails generate rys:#{origin_name} RYS_PLUGIN NAME ...same as below..."
        shell.say
        Rails::Generators.find_by_namespace(origin_name).help(shell)
      end

      def invoke_origin
        name = ARGV.shift.to_s.camelize
        plugin = "#{name}::Engine".constantize

        Rails::Generators.invoke self.class.origin_name, ARGV, behavior: :invoke, destination_root: plugin.root
      end

    end

    class Model < Base

      def self.origin_name
        'model'
      end

    end

    class Scaffold < Base

      def self.origin_name
        'scaffold'
      end

    end

    class Controller < Base

      def self.origin_name
        'controller'
      end

    end

    class Helper < Base

      def self.origin_name
        'helper'
      end

    end

    class Migration < Base

      def self.origin_name
        'migration'
      end

    end

  end
end
