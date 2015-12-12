class Kid < ActiveRecord::Base

  has_many :user_kids, dependent: :destroy
  has_many :users, through: :user_kids
  has_many :volonter_kids, dependent: :destroy
  has_many :volonters, through: :volonter_kids

  validates :name, :age, :description, :video, :address, presence: true

  enum status: [:free, :pending_send, :pending_approval] unless instance_methods.include? :status
  mount_uploader :video, VideoUploader

end
