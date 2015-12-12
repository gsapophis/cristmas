class CreateUserKids < ActiveRecord::Migration
  def change
    create_table :user_kids do |t|
      t.integer :user_id
      t.integer :kid_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :user_kids, :user_id
    add_index :user_kids, :kid_id
    add_index :user_kids, :status
  end
end
