require 'rys'
require '<%= name %>/features'

module <%= camelized %>
end

# To load after Redmine and Easy plugins
Rys.add_plugin('<%= camelized %>::Engine', '<%= name %>/engine')
