class AddVolonterIdAndUserIdToKid < ActiveRecord::Migration
  def change
    add_column :kids, :volonter_id, :integer
    add_index :kids, :volonter_id
    add_column :kids, :user_id, :integer
    add_index :kids, :user_id
  end
end
