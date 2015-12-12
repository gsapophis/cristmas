class CreateVolonterKids < ActiveRecord::Migration
  def change
    create_table :volonter_kids do |t|
      t.integer :volonter_id
      t.integer :kid_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :volonter_kids, :volonter_id
    add_index :volonter_kids, :kid_id
    add_index :volonter_kids, :status
  end
end
