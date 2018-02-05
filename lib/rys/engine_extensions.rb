module Rys
  module EngineExtensions

    DELAYED_INITIALIZERS = ['add_view_paths']

    def self.extended(base)
      super

      patches_dir = base.root.join('patches')
      Rys::Patcher.paths << patches_dir if patches_dir.directory?

      base.initializer "#{base.engine_name}.append_migrations" do |app|
        if app.root.to_s != root.to_s
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end

      base.initializer "#{base.engine_name}.delayed_initializers", after: 'load_config_initializers' do |app|
        origin_initializers.select{|i| DELAYED_INITIALIZERS.include?(i.name.to_s) }.each do |i|
          i.run(app)
        end
      end

      base.class_eval do
        alias_method :origin_initializers, :initializers

        def initializers
          super.reject{|i| DELAYED_INITIALIZERS.include?(i.name.to_s) }
        end
      end

    end

    # Experimental function
    #
    def lib_dependency_files(&block)
      files = Array(block.call)
      abosulte_files = files.map do |file|
        root.join('lib', "#{file}.rb")
      end

      initializer "#{engine_name}.dependency_files" do |app|
        reloader = ActiveSupport::FileUpdateChecker.new(abosulte_files) do
          files.each do |file|
            require_dependency file
          end
        end

        app.reloaders << reloader

        config.to_prepare do
          reloader.execute
        end
      end
    end

  end
end
