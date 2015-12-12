class AccessToken < ActiveRecord::Base
  belongs_to :volonter

  validates :volonter, presence: true

  before_create :generate_value

  private

  def generate_value
    if value.nil?
      begin
        self.value = SecureRandom.hex
      end while AccessToken.where(value: value).exists?
    end
  end
end
