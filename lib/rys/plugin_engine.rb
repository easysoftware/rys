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

  end
end
