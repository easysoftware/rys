Easy::Patcher.add('IssuesController') do

  # More possibilities:
  #
  # patch 'IssuesController', 'ProjectsController'
  # patch_if -> { Rails.version > 5 }
  # position :first
  # after 'DocumentsController'
  # type :controller
  # apply_once

  # included do
  #   before_action :add_flash_notice, only: [:show]
  # end
  #
  # instance_methods do
  #   def show
  #     Easy::Feature.on('issue.show.timeentries_details') do
  #       @timeentries_details = @issue.time_entries.count
  #     end
  #
  #     super
  #   end
  #
  #   private
  #
  #     def add_flash_notice
  #       if Easy::Feature.active?('issue.show.project_details', 'issue.show.timeentries_details')
  #         flash.now[:notice] = 'Features are activated'
  #       end
  #     end
  # end
  #
  #
  # instance_methods(feature: 'issue.show.project_details') do
  #   def show
  #     @project_details = @issue.project.name
  #
  #     super
  #   end
  # end
  #
  # class_methods do
  # end

end
