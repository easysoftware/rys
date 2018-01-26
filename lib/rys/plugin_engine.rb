module Rys
  module PluginEngine

    def self.extended(base)
      super

      patches_dir = base.root.join('patches')
      Rys::Patcher.paths << patches_dir if patches_dir.directory?

      base.initializer 'rys.append_migrations' do |app|
        if app.root.to_s != root.to_s
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
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
