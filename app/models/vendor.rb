class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, :description, :contact_name, :contact_phone, presence: true
  validates_inclusion_of :credit_accepted, in: [true, false], message: "can't be blank"


  # IDEA FOR METHOD
  # if credit_accepted.nil?
  # return error message
end
