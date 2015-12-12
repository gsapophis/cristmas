class AddVideoToVolonterKid < ActiveRecord::Migration
  def change
    add_column :volonter_kids, :video, :string
  end
end
