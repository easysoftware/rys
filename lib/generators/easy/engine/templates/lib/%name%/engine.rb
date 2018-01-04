require 'easy_core'
module <%= camelized %>
  class Engine < ::Rails::Engine
    extend Easy::PluginEngine

    initializer '<%= name %>.setup' do
      require '<%= name %>/hooks'
    end

  end
end
