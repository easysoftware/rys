module Rys
  class PluginsManagement

    mattr_accessor :all_plugins
    self.all_plugins = []

    # Backward compatibility
    def self.instance
      ActiveSupport::Deprecation.warn('.instance method is deprecated')
      self
    end

    def self.add(engine_klass)
      all_plugins << engine_klass
    end

    # @param delegate_with [Delegator] Wrap plugin with this delegator
    # @param systemic [true, false] Returns also systemic ryses
    def self.all(delegate_with: nil, systemic: false)
      plugins = all_plugins.dup

      if !systemic
        plugins.reject! {|p| systemic_plugin?(p) }
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
        all_plugins.find{|p| p.rys_id == plugin.to_s }
      when ::Rails::Engine
        all_plugins.find{|p| p == plugin }
      end
    end

    private

    def self.systemic_plugin?(p)
      p.module_parent.config.systemic
    end

  end
end
