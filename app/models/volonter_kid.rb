class VolonterKid < ActiveRecord::Base

  belongs_to :volonter
  belongs_to :kid

  enum status: [:pending_approval, :received] unless instance_methods.include? :status

  mount_uploader :video, VideoUploader

  def self.kids_by_volonter(id)
    Kid.where(id: VolonterKid.find_by(volonter_id: id).try(:kid_id))
  end
end
