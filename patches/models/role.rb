Rys::Patcher.add('Role') do

  instance_methods do

    def setable_permissions
      permissions = super
      permissions.delete_if do |permission|
        permission.rys_feature && !Rys::Feature.active?(*permission.rys_feature)
      end
      permissions
    end

  end

end
