module Rys
  class PatchGenerator < Rys::PatchGeneratorBase
    source_root File.expand_path('templates', __dir__)

    argument :type, desc: 'Type of patch. Could be controller (c), model (m), helper (h) or other (o). Default is other.',
                    required: true

    argument :plugin, desc: 'Name of rys plugin.',
                      type: :string,
                      required: true

    argument :name, desc: 'Name of the patch.',
                    type: :string

    def initialize(*args)
      super

      self.name ||= 'patch'

      begin
        plugin_engine = "#{plugin.camelize}::Engine".constantize
        self.destination_root = plugin_engine.root
      rescue NameError
        raise Rails::Generators::Error, "Plugin '#{plugin.camelize}' does not exist."
      end
    end

    def create_patch
      create_patch_by_type
    end

  end
end
