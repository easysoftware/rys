module Rys
  module PluginsManagement
    extend self

    mattr_accessor :plugins
    self.plugins = {}

    def add(klass_name, path)
      plugins[klass_name] = path
    end

    def load_all
      plugins.each do |klass_name, path|
        require path

        app = Rails.application
        klass = klass_name.constantize

        klass.run_initializers(:default, app)
      end
    end

  end
end
