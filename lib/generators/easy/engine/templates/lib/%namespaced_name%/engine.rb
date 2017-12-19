<%= wrap_in_modules <<-rb.strip_heredoc
  class Engine < ::Rails::Engine
    extend ::EasySoftware::Compositor::Engine
  #{mountable? ? '  isolate_namespace ' + camelized_modules : ' '}
  #{api? ? "  config.generators.api_only = true" : ' '}
    #{'config.autoload_paths += %W( #{config.root}/lib )'}
  end
rb
%>
