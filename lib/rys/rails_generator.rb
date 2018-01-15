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
