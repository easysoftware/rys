require 'rys/engine'
require 'rys/featured_routes'

module Rys
  autoload :Patcher,            'rys/patcher'
  autoload :Feature,            'rys/feature'
  autoload :EngineExtensions,   'rys/engine_extensions'
  autoload :PluginsManagement,  'rys/plugins_management'
  autoload :PatchGeneratorBase, 'rys/patch_generator_base'
end
