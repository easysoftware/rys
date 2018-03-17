class RysFeatureRecord < ActiveRecord::Base
  self.table_name = 'rys_features'

  scope :registered, proc { where(name: Rys::Feature.all_features.keys) }

  def self.migrate_new
    return unless table_exists?

    saved_names = pluck(:name)
    unsaved_names = Rys::Feature.all_features.keys - saved_names

    unsaved_names.each do |name|
      create!(name: name, active: true)
    end
  end

  def self.request_store
    if !RequestStore.store.has_key?(:rys_features_request_store)
      RequestStore.store[:rys_features_request_store] = {}
    end

    RequestStore.store[:rys_features_request_store]
  end

  def self.active?(full_key)
    record = (request_store[full_key] ||= find_by(name: full_key))
    record && record.active?
  end

end
