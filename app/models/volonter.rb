class Volonter < ActiveRecord::Base

  devise :database_authenticatable, :trackable, :validatable

  has_many :kids

end
