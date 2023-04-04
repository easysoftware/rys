module Rys

  autoload :Patcher, 'rys/patcher'
  autoload :Feature, 'rys/feature'
  autoload :EngineExtensions, 'rys/engine_extensions'
  autoload :PluginsManagement, 'rys/plugins_management'
  autoload :PatchGeneratorBase, 'rys/patch_generator_base'
  autoload :Reloader, 'rys/reloader'
  autoload :Hook, 'rys/hook'

  def self.apply_patches!
    dirs = {}
    Rys::Patcher.paths.each do |path|
      dirs[path.to_s] = ['rb']
    end

    patches_reloader = ActiveSupport::FileUpdateChecker.new([], dirs) do
      Rys::Patcher.reload_patches
    end
    patches_reloader.execute
    Rails.application.reloaders << patches_reloader

    Rails.application.config.to_prepare do
      patches_reloader.execute_if_updated
      Rys::Patcher.apply
      Rys::Patcher.applied_count += 1
    end
  end
  def self.utils
    Utils
  end

end

require 'rys/engine'
require 'rys/featured_routes'
require 'rys/middleware/feature_preload'
