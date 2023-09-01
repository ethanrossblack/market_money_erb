class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market_id, :vendor_id, presence: true
  validates :market_id, uniqueness: { 
    scope: :vendor_id,
    message: ->(market_vendor, data) do
      "vendor association between market with market_id=#{market_vendor.market_id} and vendor with vendor_id=#{market_vendor.vendor_id} already exists"
    end
  }
end
