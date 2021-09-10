module Rys
  # Ensure migrations for all RYSy
  class Migrate
    class << self

      # db:migrate - database scheme
      def db
        call("migrate")
      end

      # data:migrate - this execute data load after all plugins are migrated / loaded
      def data
        call("after_plugins")
      end

      private

      # @param [String] source - +migrate+ or +after_plugins+
      def call(source)
        PluginsManagement.all(systemic: true) do |plugin|
          version = ENV['VERSION'].presence
          existent_dirs = plugin.paths["db/#{source}"].existent

          puts "Migrating #{plugin} #{source} ..."
          unless ActiveRecord::Base.connection_db_config.name == 'primary'
            ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations.configs_for(name: 'primary'))
          end
          ActiveRecord::MigrationContext.new(existent_dirs, ::ActiveRecord::Base.connection.schema_migration).migrate(version)
        end

        Rake::Task["db:schema:dump"].reenable
        Rake::Task["db:schema:dump"].invoke
      end

    end

  end
end
