require 'singleton'

module Rys
  class PluginsManagement
    include Singleton
    attr_reader :plugins

    def self.add(engine_klass)
      instance.add(engine_klass)
    end

    def self.all
      if block_given?
        instance.plugins.each do |plugin|
          yield plugin
        end
      else
        instance.plugins
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
