module Easy
  module PluginEngine

    def self.extended(base)
      super

      patches_dir = base.root.join('patches')
      Easy::Patcher.paths << patches_dir if patches_dir.directory?
    end

  end
end
