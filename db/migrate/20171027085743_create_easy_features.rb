class CreateEasyFeatures < ActiveRecord::Migration

  def up
    create_table :easy_features, force: true do |t|
      t.string :name, null: false, index: true
      t.boolean :active, null: false
    end
  end

  def down
    drop_table :easy_features
  end

end
