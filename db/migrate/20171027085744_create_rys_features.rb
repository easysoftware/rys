class CreateRysFeatures < ActiveRecord::Migration

  def change
    create_table :rys_features, force: true do |t|
      t.string :name, null: false, index: true
      t.boolean :active, null: false

      t.timestamps null: false
    end
  end

end
