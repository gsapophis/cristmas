class Kid < ActiveRecord::Base

  belongs_to :user
  belongs_to :volonter

  # validates :name, :age, :description, :video, :address, presence: true

  enum status: [:free, :in_list, :pending_send, :pending_approval, :received, :approved] unless instance_methods.include? :status

  mount_uploader :video, VideoUploader

  def deliver!
    self.update_columns(status: 3)
  end
end
