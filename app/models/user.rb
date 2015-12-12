class User < ActiveRecord::Base

  has_many :user_kids, dependent: :destroy
  has_many :kids, through: :user_kids
end
