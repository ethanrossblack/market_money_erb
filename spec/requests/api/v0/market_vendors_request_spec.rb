require 'rails_helper'

describe "MarketVendor API Endpoint ('/api/v0/market_vendors')" do
  describe "Create a MarketVendor (POST '/')" do
    describe "happy path" do
      before do
        @market = create(:market)
        @vendor = create(:vendor)
        @mv_params = {
          market_id: @market.id,
          vendor_id: @vendor.id
        }
        @headers = {"CONTENT_TYPE": "application/json"}
      end

      it "can create a new association between market and vendor when given valid market+vendor ids" do
        post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(market_vendor: @mv_params)
        
        # Verify that the endpoint actually created a new vendor resource
        new_market_vendor = MarketVendor.last
        expect(new_market_vendor.market_id).to eq(@market.id)
        expect(new_market_vendor.vendor_id).to eq(@vendor.id)

        # Verify that the endpoint returned a successful creation response
        expect(response).to be_successful
        expect(response.status).to eq(201)

        # Verify that the response is formatted correctly
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a Hash
        expect(json).to have_key(:message)
        expect(json[:message]).to eq("Successfully added vendor to market")

        post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(market_vendor: @mv_params)
      end
    end

    describe "sad path" do
      before do
        @market = create(:market)
        @vendor = create(:vendor)
        @mv_params = {
          market_id: @market.id,
          vendor_id: @vendor.id
        }
        @headers = {"CONTENT_TYPE": "application/json"}
      end
      it "returns a 422 :unprocessable_entity response if a MarketVendor already exists with the requested market_id and vendor_id" do
        MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)

        post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(market_vendor: @mv_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to have_key(:errors)
        expect(json[:errors]).to be_an Array
        expect(json[:errors].count).to eq(1)
        
        expect(json[:errors][0]).to be_a Hash
        expect(json[:errors][0]).to have_key(:detail)
        expect(json[:errors][0][:detail]).to eq("Validation failed: Market vendor association between market with market_id=#{@market.id} and vendor with vendor_id=#{@vendor.id} already exists")
      end
      
      it "returns a 400 status code if any attributes are missing" do
        missing_params = {
          market_id: "",
          vendor_id: ""
        }

        post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(market_vendor: missing_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        # I DON"T HAVE TIME TO FINISH THIS TEST BUT I WOULD LIKE TO FINISH IT
      end
    end
  end
end