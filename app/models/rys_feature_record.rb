class RysFeatureRecord < ActiveRecord::Base
  self.table_name = 'rys_features'

  scope :enabled, proc { where(name: Rys::Feature.all_features.keys) }

  def self.migrate_new
    return unless table_exists?

    saved_names = pluck(:name)
    unsaved_names = Rys::Feature.all_features.keys - saved_names

    unsaved_names.each do |name|
      create!(name: name, active: true)
    end
  end

end
