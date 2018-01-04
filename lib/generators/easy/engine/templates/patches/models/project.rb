Easy::Patcher.add('Project') do
  # More possibilities:
  #
  # patch 'IssuesController', 'ProjectsController'
  # patch_if -> { Rails.version > 5 }
  # position :first
  # after 'DocumentsController'
  # type :controller
  # apply_once

  # included do
  #   has_many :things
  #
  #   after_commit :ensure_something, if: -> { Easy::Feature.active?('issue') }
  # end
  #
  # instance_methods do
  #   def some_method
  #     Easy::Feature.on('issue.show') do
  #       ---
  #     end
  #
  #     super
  #   end
  #
  #   private
  #
  #     def some_private_m
  #       if Easy::Feature.active?('issue.show.project_details', 'issue.show.timeentries_details')
  #         'Features are activated'
  #       end
  #     end
  # end
  #
  #
  # instance_methods(feature: 'issue.show.project_details') do
  #   def to_s
  #     'Iam coool' + super
  #   end
  # end
  #
  # class_methods do
  # end



end
