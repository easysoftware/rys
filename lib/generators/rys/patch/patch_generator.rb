module Rys
  class PatchGenerator < Rails::Generators::Base
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
      case type
      when 'controller', 'c'
        create_controller_patch
      when 'model', 'm'
        create_model_patch
      when 'helper', 'h'
        create_helper_patch
      when 'other', 'o'
        create_other_patch
      else
        raise Rails::Generators::Error, 'Type must be controller, model, helper or other.'
      end
    end

    def name_underscore
      name.underscore
    end

    def controller_name_underscore
      name_underscore.end_with?('_controller') ? name_underscore : "#{name_underscore}_controller"
    end

    def helper_name_underscore
      name_underscore.end_with?('_helper') ? name_underscore : "#{name_underscore}_helper"
    end

    def name_camelize
      name.camelize
    end

    def controller_name_camelize
      name_camelize.end_with?('Controller') ? name_camelize : "#{name_camelize}Controller"
    end

    def helper_name_camelize
      name_camelize.end_with?('Helper') ? name_camelize : "#{name_camelize}Helper"
    end

    private

      def create_controller_patch
        template 'controller_patch.rb', "patches/controllers/#{controller_name_underscore}.rb"
      end

      def create_model_patch
        template 'model_patch.rb', "patches/models/#{name_underscore}.rb"
      end

      def create_helper_patch
        template 'helper_patch.rb', "patches/helpers/#{helper_name_underscore}.rb"
      end

      def create_other_patch
        template 'other_patch.rb', "patches/others/#{name_underscore}.rb"
      end

  end
end
