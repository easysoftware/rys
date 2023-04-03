module Rys
  class Engine < ::Rails::Engine
    Rys::Patcher.paths << root.join('patches')

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

    # Access control should be patch before any initializers/*
    # because that is the place where all permissions are defined
    initializer 'rys.access_control', before: :load_config_initializers do
      require 'rys/access_control'
    end

    initializer 'rys.append_migrations' do |app|
      if defined?(ENGINE_ROOT) && root.to_s == ENGINE_ROOT
        # Rails is loaded through this engine
        # and migrations are automatically added
      else
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    initializer 'rys.features' do |app|
      app.middleware.use ::Rys::Middleware::FeaturePreload
    end

    config.after_initialize do |app|
      RysFeatureRecord.migrate_new
    end

    # For patches where you set
    #   where :earlier_to_prepare
    #
    # Useful when you need something before loading easy plugins
    Rys::Reloader.to_prepare do
      Rys::Patcher.apply(where: :earlier_to_prepare)
    end

  end
end
