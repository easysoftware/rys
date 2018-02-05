module <%= camelized %>
  class Engine < ::Rails::Engine
    extend Rys::EngineExtensions

    initializer '<%= name %>.setup' do
      require '<%= name %>/hooks'

      # Redmine::MenuManager.map :top_menu do |menu|
      #
      # end

      # Redmine::AccessControl.map do |map|
      #
      # end
    end

  end
end
