module Rys
  class PatchGeneratorBase < Rails::Generators::Base

    private

      def create_patch_by_type
        case type.to_s.downcase
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

      # def full_name_by_type
      #   case type.to_s.downcase
      #   when 'controller', 'c'
      #     controller_name_camelize
      #   when 'helper', 'h'
      #     helper_name_camelize
      #   else
      #     name_camelize
      #   end
      # end

      def controller_name_camelize
        name_camelize.end_with?('Controller') ? name_camelize : "#{name_camelize}Controller"
      end

      def helper_name_camelize
        name_camelize.end_with?('Helper') ? name_camelize : "#{name_camelize}Helper"
      end

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
