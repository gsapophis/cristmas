class Kid < ActiveRecord::Base

  has_many :user_kids, dependent: :destroy
  has_many :users, through: :user_kids

  enum status: [:free, :pending_send, :pending_approval] unless instance_methods.include? :status
end
