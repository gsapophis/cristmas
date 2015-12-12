class Volonter < ActiveRecord::Base

  has_many :volonter_kids, dependent: :destroy
  has_many :kids, through: :volonter_kids
end
