class VolonterKid < ActiveRecord::Base

  belongs_to :volonter
  belongs_to :kid

  enum status: [:pending_approval, :received] unless instance_methods.include? :status

  scope :kids_by_volonter, ->(id) { Kid.where(id: VolonterKid.find_by(volonter_id: id).try(:kid_id)) }

  mount_uploader :video, VideoUploader
end
