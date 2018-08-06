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
      _original_rys_feature = @rys_feature
      @rys_feature = Array(@rys_feature) + names
      @rys_feature.uniq!

      yield self
    ensure
      @rys_feature = _original_rys_feature
    end

    def permission(name, hash, options={})
      options.merge!(rys_feature: @rys_feature)
      super
    end

  end
end

module Rys
  module RedmineAccessControlPermission

    def initialize(name, hash, options)
      super
      @rys_feature = options[:rys_feature]
    end

    def rys_feature
      @rys_feature
    end

  end
end

Redmine::AccessControl::Mapper.prepend(Rys::RedmineAccessControlMapper)
Redmine::AccessControl::Permission.prepend(Rys::RedmineAccessControlPermission)
