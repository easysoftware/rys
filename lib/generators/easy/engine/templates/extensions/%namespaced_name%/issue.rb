module Extensions
  <%= wrap_in_modules <<-rb.strip_heredoc
    module Issue
      def to_s
        if EasyFeature.active?(:#{underscored_name})
          '#{underscored_name.pluralize}' + ' rocks'
        else
          super
        end
      end
    end
  rb
  %>
end
EasySoftware::Compositor.register_patch(:<%= underscored_name %>, 'Issue', 'Extensions::<%= camelized_modules %>::Issue')
