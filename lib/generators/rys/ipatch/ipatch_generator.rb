module Rys
  class IpatchGenerator < Rys::PatchGeneratorBase
    source_root File.expand_path('../patch/templates', __dir__)

    attr_reader :type, :plugin, :name

    def create_patch
      require 'tty-prompt'
      @prompt = TTY::Prompt.new(interrupt: :exit)

      @plugin = @prompt.select('Choose target plugin') do |menu|
        Rys::PluginsManagement.instance.plugins.each do |plugin|
          menu.choice plugin.name, plugin
        end
      end

      self.destination_root = plugin.root

      loop {
        run
        @prompt.say('---')
        break if !@prompt.yes?('Add more?')
      }
    end

    private

      def run
        @type = nil
        @name = nil

        @type = @prompt.select('Choose patch type', ['Controller', 'Model', 'Helper', 'Other'])
        @name = @prompt.ask('Name of class or module:', required: true)

        create_patch_by_type
      end

  end
end
