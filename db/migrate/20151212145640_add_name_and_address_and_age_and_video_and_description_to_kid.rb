class AddNameAndAddressAndAgeAndVideoAndDescriptionToKid < ActiveRecord::Migration
  def change
    add_column :kids, :name, :string
    add_index :kids, :name
    add_column :kids, :address, :string
    add_index :kids, :address
    add_column :kids, :age, :integer
    add_index :kids, :age
    add_column :kids, :video, :string
    add_column :kids, :description, :text
  end
end
