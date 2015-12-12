class VolonterKid < ActiveRecord::Base

  belongs_to :volonter
  belongs_to :kid

  enum status: [:pending_approval, :received] unless instance_methods.include? :status
end
