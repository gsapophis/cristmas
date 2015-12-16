class AddTweetImageUrlToKid < ActiveRecord::Migration
  def change
    add_column :kids, :tweet_image_url, :string
  end
end
