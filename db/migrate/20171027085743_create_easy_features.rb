class CreateEasyFeatures < ActiveRecord::Migration

  def up
    create_table :easy_features do |t|
      t.string :name, null: false, index: true
      t.boolean :status, null: false
    end
  end

  def down
    drop_table :easy_features
  end

end
