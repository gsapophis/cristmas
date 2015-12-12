class CreateVolonters < ActiveRecord::Migration
  def change
    create_table :volonters do |t|

      t.timestamps null: false
    end
  end
end
