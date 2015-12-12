class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :kids, :status
  end
end
