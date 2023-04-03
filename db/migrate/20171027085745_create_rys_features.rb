class CreateRysFeatures < ActiveRecord::Migration[5.2]

  def change
    create_table :rys_features, force: true do |t|
      t.string :name, null: false, index: true
      t.boolean :active, null: false

      t.timestamps null: false
    end

    add_index :rys_features, :name, unique: true, name: 'unique_index_rys_features_name'
  end

end
