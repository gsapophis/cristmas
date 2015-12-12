class Kid < ActiveRecord::Base

  belongs_to :user
  belongs_to :volonter

  validates :name, :age, :description, :video, :address, presence: true

  enum status: [:free, :in_list, :pending_approval, :delivered] unless instance_methods.include? :status

  mount_uploader :video, VideoUploader
  mount_uploader :feedback_video, FeedbackVideoUploader

  def add_to_pending(id)
    self.update_columns(user_id: id, status: 1) unless self.user_id
  end

  def accept_sending
    self.update_columns(status: 2)
  end

  def remove_from_list
    self.update_columns(status: 0, user_id: nil)
  end

  def delivered!(video)
    self.update_attributes(feedback_video: video, status: 3)
  end
end
