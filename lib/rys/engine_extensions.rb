module Rys
  module EngineExtensions

    def self.included(base)
      base.extend(ClassMethods)

      patches_dir = base.root.join('patches')
      Rys::Patcher.paths << patches_dir if patches_dir.directory?

      base.class_attribute :initializers_moves
      base.initializers_moves = []

      base.initializer :append_migrations do |app|
        if app.root.to_s != root.to_s
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end

      # To load after Redmine
      base.config.before_configuration do |app|
        app.config.railties_order.unshift(base)
      end

      # To prepend view path after Redmine and plugins
      base.move_initializer(:add_view_paths, after: :load_config_initializers)
    end

    def initializers
      @changed_initializers ||= begin
        original_initializers = super
        new_initializers = []

        initializers_moves.each do |moves|
          initializer = original_initializers.find{|i| i.name == moves[:name] }
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
      # Also you must use the same name as orignal. String is different than Symbol.
      #
      #   move_initializer(:add_view_paths, after: :load_config_initializers)
      #
      # More informations: http://guides.rubyonrails.org/configuring.html#initialization-events
      #
      def move_initializer(name, before: nil, after: nil)
        initializers_moves << { name: name, before: before, after: after }
      end

    end

  end
end
