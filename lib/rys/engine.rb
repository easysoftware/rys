module Rys
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.integration_tool :rspec
      g.assets false
      g.helper false
    end

    generators do
      config.app_generators.integration_tool 'rys:rspec'
      config.app_generators.test_framework 'rys:rspec'

      # Rails hide by default `#{test_framework}:*`
      ::Rails::Generators.hidden_namespaces.reject! do |namespace|
        namespace.to_s.start_with?('rys:rspec')
      end

      require 'rys/rails_generator'
    end

    # All plugins must be loaded now!!!
    config.before_initialize do |app|
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
        Rys::Patcher.applied_count += 1
      end
    end

    initializer 'rys.features' do |app|
      if defined?(ENGINE_PATH) && root.to_s == ENGINE_PATH
        # Rails is loaded through this engine
        # and migrations are automatically added
      else
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end

      app.middleware.use 'Rys::FeaturePreload'
      RysFeatureRecord.migrate_new
    end

    initializer 'rys.menu_manager' do
      Redmine::MenuManager.map :admin_menu do |menu|
        menu.push :rys_features, :rys_features_path,
          if: proc { User.current.admin? },
          html: { class: 'icon icon-package' },
          last: true
      end
    end

    # For patches where you set
    #   where :earlier_to_prepare
    #
    # Useful when you nedd something before loading easy plugins
    ActionDispatch::Reloader.to_prepare do
      Rys::Patcher.apply(where: :earlier_to_prepare)
    end

  end
end
