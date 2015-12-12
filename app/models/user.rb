class User < ActiveRecord::Base
  PROVIDERS = [:facebook]
  PROVIDERS_S = %w(facebook)

  devise :database_authenticatable, :trackable, :validatable, :omniauthable,
         omniauth_providers: PROVIDERS

  has_many :user_kids, dependent: :destroy
  has_many :kids, through: :user_kids
end
