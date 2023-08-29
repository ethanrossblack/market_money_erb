require "rails_helper"

describe Market, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    before do
      @market = create(:market)
    end
    
    it "#vendor_count" do
      # Returns 0 for a market with no vendors
      expect(@market.vendor_count).to eq(0)

      vendor1 = create(:vendor)
      MarketVendor.create!(market_id: @market.id, vendor_id: vendor1.id)
      
      expect(@market.vendor_count).to eq(1)
      
      vendor2 = create(:vendor)
      MarketVendor.create!(market_id: @market.id, vendor_id: vendor2.id)
      vendor3 = create(:vendor)
      MarketVendor.create!(market_id: @market.id, vendor_id: vendor3.id)

      expect(@market.vendor_count).to eq(3)
    end
  end
end
