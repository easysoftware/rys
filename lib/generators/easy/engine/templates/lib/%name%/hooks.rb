module <%= camelized %>
  class Hooks < ::Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'issues/view_issues_show_details_bottom'
  end
end
