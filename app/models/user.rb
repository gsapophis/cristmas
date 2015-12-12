class User < ActiveRecord::Base
  PROVIDERS = [:facebook]
  PROVIDERS_S = %w(facebook)

  devise :database_authenticatable, :trackable, :validatable, :omniauthable,
         omniauth_providers: PROVIDERS

  has_many :kids
  has_one  :profile, dependent: :destroy
  has_many :user_authorizations, dependent: :destroy

  delegate :image, to: :profile

  after_create :build_profile_association

  def add_to_favorite(id)
    kid = Kid.find(id)
    kid.update_colums(user_id: id) unless kid.user_id
  end

  protected

  def build_profile_association
    self.create_profile unless self.profile
  end
end
