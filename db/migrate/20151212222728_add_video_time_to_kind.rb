class AddVideoTimeToKind < ActiveRecord::Migration
  def change
    add_column :kids, :video_duration, :string
    add_column :kids, :feedback_video_duration, :string
    add_index :kids, :video_duration
    add_index :kids, :feedback_video_duration
  end
end
