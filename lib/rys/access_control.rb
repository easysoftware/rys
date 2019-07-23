require 'redmine/access_control'

module Rys
  module RedmineAccessControlMapper

    # Set feature to every permission defined within the block
    #
    # @param *names [Array<String,Symbol>] Rys features
    # @yield [Redmine::AccessControl::Mapper] Mapper instance
    #
    # @example Condition permission by feature
    #   Redmine::AccessControl.map do |map|
    #     map.rys_feature('feature_my_rys') do |featured_map|
    #       featured_map.permission(:view_my_rys, {})
    #     end
    #   end
    #
    def rys_feature(*names)
      original_rys_feature = @rys_feature
      original_permissions = @permissions&.dup

      # An array must be rewrited
      @rys_feature = Array(@rys_feature) + names
      @rys_feature.uniq!

      yield self
    ensure
      # This "nice" thing is because of patch ordering
      # If feature would be added in constructor:
      #     #initialize call super
      #     super call initialize_with_easy_extensions
      #     initialize_with_easy_extensions call initialize_without_easy_extensions
      #     initialize_without_easy_extensions call #initialize again
      #
      newly_added = Array(@permissions) - Array(original_permissions)
      newly_added.each do |permission|
        permission.instance_variable_set(:@rys_feature, @rys_feature)
      end
      @rys_feature = original_rys_feature
    end

    # def permission(name, hash, options={})
    #   options.merge!(rys_feature: @rys_feature)
    #   super
    # end

  end
end

module Rys
  module RedmineAccessControlPermission

    # FIXME: Wait for platform modifications
    #
    # def initialize(name, hash, options)
    #   super
    #   @rys_feature = options[:rys_feature]
    # end

    def rys_feature
      @rys_feature
    end

  end
end

Redmine::AccessControl::Mapper.prepend(Rys::RedmineAccessControlMapper)
Redmine::AccessControl::Permission.prepend(Rys::RedmineAccessControlPermission)
