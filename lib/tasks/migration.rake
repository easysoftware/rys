require "rys/migrate"

namespace :rys do
  namespace :migrate do
    # This task is not used anymore, installation needs specify order and its defined in installer.rake itself in `easy_extensions`
    desc 'Migrate ryses db/after_plugins'
    task after_plugins: :environment do
      Rys::Migrate.data
    end

    task plugins: :environment do
      Rys::Migrate.db
    end
  end
end
