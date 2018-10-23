module Rys
  autoload :Patcher,            'rys/patcher'
  autoload :Feature,            'rys/feature'
  autoload :EngineExtensions,   'rys/engine_extensions'
  autoload :PluginsManagement,  'rys/plugins_management'
  autoload :PatchGeneratorBase, 'rys/patch_generator_base'
  autoload :Reloader,           'rys/reloader'
  autoload :Hook,               'rys/hook'
  autoload :Utils,              'rys/utils'
  autoload :Config,             'rys/config'

  def self.utils
    Utils
  end
end

require 'rys/engine'
require 'rys/featured_routes'
