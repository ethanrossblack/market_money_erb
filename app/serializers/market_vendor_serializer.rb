class MarketVendorSerializer
  def initialize(market_vendor)
    @market_vendor = market_vendor
  end

  def serialize_json
    {
      "message": "Successfully added vendor to market"
    }
  end
end
