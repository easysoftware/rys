# Are you sure?
# require 'rails/all'

module Rys
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.assets false
      g.helper false
    end

    initializer 'rys.patches' do |app|
      dirs = {}
      Rys::Patcher.paths.each do |path|
        dirs[path.to_s] = ['rb']
      end

      patches_reloader = ActiveSupport::FileUpdateChecker.new([], dirs) do
        Rys::Patcher.reload_patches
      end
      patches_reloader.execute
      app.reloaders << patches_reloader

      config.to_prepare do
        patches_reloader.execute_if_updated
        Rys::Patcher.apply
      end
    end

    initializer 'rys.features' do |app|
      # Tu run just `db:migrate`
      if app.root.to_s != root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end

      app.middleware.use 'Rys::FeaturePreload'
      RysFeatureRecord.migrate_new
    end

  end
end
