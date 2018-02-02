require 'rys/engine'
require 'rys/featured_routes'

module Rys
  autoload :Patcher,           'rys/patcher'
  autoload :Feature,           'rys/feature'
  autoload :PluginEngine,      'rys/plugin_engine'
  autoload :PluginsManagement, 'rys/plugins_management'

  def self.add_plugin(*args)
    PluginsManagement.add(*args)
  end

end
