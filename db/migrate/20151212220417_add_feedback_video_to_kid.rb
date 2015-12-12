class AddFeedbackVideoToKid < ActiveRecord::Migration
  def change
    add_column :kids, :feedback_video, :string
  end
end
