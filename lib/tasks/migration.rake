require "rys/migrate"

namespace :rys do
  namespace :migrate do
    desc 'Migrate ryses db/after_plugins'
    task after_plugins: :environment do
      Rys::Migrate.data
    end

    task plugins: :environment do
      Rys::Migrate.db
    end
  end
end

namespace :redmine do
  namespace :plugins do
    # == Problem:
    # Imagine situation when you have an empty database and
    # migration which adds new EasyPage.
    #
    # If your app is not migrated -> easyproject will not start.
    #
    # But ryses plugins are migrated and EasyPage cannot be created.
    # For Rails is migration migrated and you cannot do anything.
    #
    # == Solution:
    # This file is loaded before redmine.rake so this add task
    # which will be triggered before original one.
    #
    # 1. This task is invoked
    # 2. Register after callback
    # 3. Original is invoked
    # 4. Callback is invoked
    #
    # == Different solution?
    # That will be great. Just make a Merge Request.
    #
    # Load ordering:
    #   - Rails engines tasks
    #   - App's tasks (lib/tasks)
    #   - Rails tasks
    #
    # task migrate: :environment do
    #   if ENV['NAME'].blank?
    #     if defined?(APP_RAKEFILE) && (defined?(ENGINE_PATH) || defined?(ENGINE_ROOT))
    #       prefix = 'app:'
    #     end
    #
    #     Rake::Task["#{prefix}redmine:plugins:migrate"].enhance do
    #       Rake::Task["#{prefix}rys:migrate:after_plugins"].invoke
    #     end
    #   end
    # end
  end
end
