class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :image
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :profiles, :user_id
  end
end
