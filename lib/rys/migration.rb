module Rys

  if Rys.utils.rails5?

    class Migration < ActiveRecord::Migration[4.2]
    end

  else

    class Migration < migration_class
      def self.[](*)
        self
      end
    end

  end

end
