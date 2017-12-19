module Easy
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.assets false
      g.helper false
    end

    initializer 'easy.patches' do |app|
      dirs = {}
      Easy::Patcher.paths.each do |path|
        dirs[path.to_s] = ['rb']
      end

      patches_reloader = ActiveSupport::FileUpdateChecker.new([], dirs) do
        Easy::Patcher.reload_patches
      end
      patches_reloader.execute
      app.reloaders << patches_reloader

      config.to_prepare do
        patches_reloader.execute_if_updated
        Easy::Patcher.apply
      end
    end

    initializer 'easy.features' do |app|
      # To avoid
      #   easy:install:migrations
      #
      if !app.root.to_s.match(root.to_s)
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end

      app.middleware.use Easy::FeaturePreload
      EasyFeatureRecord.migrate_new
    end

  end
end
