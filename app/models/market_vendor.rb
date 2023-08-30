class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  # validates_uniqueness_of: :market_id, scope: :vendor_id, message: "Message,,etc"
end

# begin
  
# rescue => exception
#   controller``
# end

# rescue standardError



#   valida