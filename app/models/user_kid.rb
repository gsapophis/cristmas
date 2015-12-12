class UserKid < ActiveRecord::Base

  belongs_to :user
  belongs_to :kid

  enum status: [:in_list, :pending_approval, :received] unless instance_methods.include? :status
end
