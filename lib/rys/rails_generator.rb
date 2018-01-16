module Rys
  module RailsGenerator
    class Model < ::Rails::Generators::NamedBase

      def self.help(shell)
        shell.say "Usage for Rys:"
        shell.say "  rails generate rys:model RYS_PLUGIN NAME ...same as below..."
        shell.say
        Rails::Generators.find_by_namespace('model').help(shell)
      end

      def self.namespace
        "rys:model"
      end

      def invoke_origin
        plugin = ARGV.shift
        Rails::Generators.invoke 'model', ARGV, behavior: :invoke, destination_root: "rys_plugins/#{plugin}"
      end

    end
  end
end

module Rys
  module RailsGenerator
    class Scaffold < ::Rails::Generators::NamedBase

      def self.help(shell)
        shell.say "Usage for Rys:"
        shell.say "  rails generate rys:scaffold RYS_PLUGIN NAME ...same as below..."
        shell.say
        Rails::Generators.find_by_namespace('scaffold').help(shell)
      end

      def self.namespace
        "rys:scaffold"
      end

      def invoke_origin
        plugin = ARGV.shift
        Rails::Generators.invoke 'scaffold', ARGV, behavior: :invoke, destination_root: "rys_plugins/#{plugin}"
      end

    end
  end
end
