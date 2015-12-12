class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.integer :volonter_id
      t.string :value
    end
    add_index :access_tokens, :volonter_id
    add_index :access_tokens, :value
  end
end
