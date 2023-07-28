module Rys
  module EngineExtensions

    def self.included(base)
      base.extend(ClassMethods)
      base.module_parent.include(ActiveSupport::Configurable)
      base.module_parent.extend(ParentClassMethods)

      Rys::PluginsManagement.add(base)

      patches_dir = base.root.join('patches')
      Rys::Patcher.paths << patches_dir if patches_dir.directory?

      if (easy_api_dir = base.config.root.join("easy_api").directory?)
        base.config.autoload_paths << easy_api_dir.to_s
        base.config.eager_load_paths << easy_api_dir.to_s
      end

      base.class_attribute :initializers_moves
      base.initializers_moves = []

      # Only for `EasyEngine` concept in core of Easy Redmine
      ActiveSupport.on_load(:before_apply_easy_patches) do
        easy_patch_dir = base.root.join("easy_patch")
        if easy_patch_dir.exist?
          Dir.glob(easy_patch_dir.join('**/*.rb')).each do |patch_file|
            EasyDeprecation.warn(
              deprecated: "Easy Patch (#{patch_file}) in RYS",
              new_solution: "Rys::Patcher",
              documentation_link: "https://developers.easysoftware.com/docs/developer-portal-devs/ZG9jOjM5NzgxNzQz-patch-management"
            )
            require patch_file
          end
        end
      end

      # To load after Redmine
      base.config.before_configuration do |app|
        app.config.railties_order.unshift(base)
      end

      # Just register path for rys/tasks/migration.rake
      base.config.paths.add('db/after_plugins')

      # To prepend view path after Redmine and plugins
      base.move_initializer(:add_view_paths, after: :load_config_initializers)
    end

    def initializers
      @changed_initializers ||= begin
                                  original_initializers = super
                                  new_initializers = []

                                  initializers_moves.each do |moves|
                                    initializer = original_initializers.find { |i| i.name == moves[:name] }
                                    next if initializer.nil?

                                    new_initializer = initializer.dup
                                    new_initializer.instance_eval {
                                      @name = "moved.#{name}"
                                      @options = @options.dup

                                      if moves[:before]
                                        @options[:before] = moves[:before]
                                      end

                                      if moves[:after]
                                        @options[:after] = moves[:after]
                                      end
                                    }
                                    new_initializers << new_initializer

                                    # Initializer must remain
                                    initializer.instance_eval {
                                      @block = proc {}
                                    }
                                  end

                                  original_initializers + new_initializers
                                end
    end

    module ClassMethods

      # Experimental function
      #
      def lib_dependency_files(&block)
        files = Array(block.call)
        abosulte_files = files.map do |file|
          root.join('lib', "#{file}.rb")
        end

        initializer "#{engine_name}.dependency_files", before: :engines_blank_point do |app|
          reloader = ActiveSupport::FileUpdateChecker.new(abosulte_files) do
            files.each do |file|
              require_dependency file
            end
          end

          reloader.execute
          app.reloaders << reloader

          config.to_prepare do
            reloader.execute_if_updated
          end
        end
      end

      # Move initializer
      #
      # 1. Set execution block of original initializer to empty proc.
      #    Initializer remain but do nothing. This is because almost every
      #    initializer gets automatically `after` options and we cannot simply
      #    change it because others initializer may depend on it.
      # 2. New initializer is created with original execution block but under
      #    different name.
      #
      # Be very careful with using this method. Results could be unpredictable.
      # Also you must use the same name as original. String is different than Symbol.
      #
      #   move_initializer(:add_view_paths, after: :load_config_initializers)
      #
      # More information's: http://guides.rubyonrails.org/configuring.html#initialization-events
      #
      def move_initializer(name, before: nil, after: nil)
        initializers_moves << { name: name, before: before, after: after }
      end

      # Be careful for changing the name
      # For example language prefix depends on this
      def rys_id(name = nil)
        @rys_id = name.to_s if name
        @rys_id ||= ActiveSupport::Inflector.underscore(self.name).sub('/engine', '')
      end

      # for deactivation
      def plugin_active?
        true
      end

      # html partial if the plugin is deactivated
      # it is expected to be overridden by external plugins
      def deactivated_plugin_html(_view_context) end

      # true  -> enable deactivation
      # false -> always enabled
      def hosting_plugin(value = nil)
        @hosting_plugin = !!value unless value == nil
        @hosting_plugin
      end

      def disable_ryspec!
        @ryspec_disabled = true
      end

      def ryspec_disabled?
        @ryspec_disabled
      end

    end

    module ParentClassMethods

      def engine
        @engine ||= self.const_get(:Engine)
      end

    end

  end
end
