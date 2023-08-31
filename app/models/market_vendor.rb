class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market_id, :vendor_id, presence: true
  validates_uniqueness_of :market_id, scope: :vendor_id
end
