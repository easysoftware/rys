class RysFeatureRecord < ActiveRecord::Base
  self.table_name = 'rys_features'

  scope :registered, proc { where(name: Rys::Feature.all_features.keys) }
  scope :registered_for, lambda { |plugin|
    features = []

    Rys::Feature.all_features.each do |_, feature|
      if plugin.nil?
        if feature.plugins.size == 0
          features << feature
        end
      else
        if feature.plugins.include?(plugin)
          features << feature
        end
      end
    end

    where(name: features.map(&:full_key))
  }

  after_commit :update_callback, on: :update

  def self.migrate_new
    return unless table_exists?

    saved_names = pluck(:name)

    features = Rys::Feature.all_features
    features.each do |name, feature|
      next if saved_names.include?(name)
      create!(name: name, active: feature.default_db_status)
    end
  rescue ActiveRecord::NoDatabaseError
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

  def self.activate!(*full_keys)
    request_store.clear
    RysFeatureRecord.where(name: full_keys).update_all(active: true)
  end

  def feature
    Rys::Feature.all_features[name]
  end

  private

    def update_callback
      if previous_changes.has_key?(:active)
        feature.status_changed(active)
      end
    end

end
