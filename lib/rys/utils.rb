module Rys
  module Utils
    module_function

    def rails4?
      Rails::VERSION::MAJOR == 4
    end

    def rails5?
      Rails::VERSION::MAJOR == 5
    end

  end
end
