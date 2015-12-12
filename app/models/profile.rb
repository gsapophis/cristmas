class Profile < ActiveRecord::Base
  belongs_to :user, autosave: true
  has_many :user_authorizations, through: :user

  validates :user_id, presence: true

  delegate :email, :email=, :name, :name=, to: :user

  mount_uploader :image, AvatarUploader
end
