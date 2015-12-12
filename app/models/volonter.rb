class Volonter < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable

  has_many :volonter_kids, dependent: :destroy
  has_many :kids, through: :volonter_kids
end
