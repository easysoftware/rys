require 'singleton'

module Rys
  class PluginsManagement
    include Singleton
    attr_reader :plugins

    def self.add(engine_klass)
      instance.add(engine_klass)
    end

    # @param delegate_with [Delegator] Wrap plugin with this delegator
    # @param systemic [true, false] Returns also systemic ryses
    def self.all(delegate_with: nil, systemic: false)
      plugins = instance.plugins

      if !systemic
        plugins.select! {|p| !p.rys_config.systemic }
      end

      if delegate_with
        plugins.map!{|p| delegate_with.new(p) }
      end

      if block_given?
        plugins.each do |plugin|
          yield plugin
        end
      else
        plugins
      end
    end

    def self.find(plugin)
      case plugin
      when String, Symbol
        instance.plugins.find{|p| p.rys_id == plugin.to_s }
      when ::Rails::Engine
        instance.plugins.find{|p| p == plugin }
      end
    end

    def initialize
      @plugins = []
    end

    def add(engine_klass)
      @plugins << engine_klass
    end

  end
end
