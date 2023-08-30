require 'rails_helper'

describe "Markets API" do
  describe "/markets" do
    it "returns a list of all markets" do
      create_list(:market, 5)

      get "/api/v0/markets"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to have_key(:data)
      expect(json[:data]).to be_an Array

      markets = json[:data]
      expect(markets.count).to eq(5)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_a String

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a Hash

        market_attributes = market[:attributes]

        expect(market_attributes).to have_key(:name)
        expect(market_attributes[:name]).to be_a String 

        expect(market_attributes).to have_key(:street)
        expect(market_attributes[:street]).to be_a String 

        expect(market_attributes).to have_key(:city)
        expect(market_attributes[:city]).to be_a String 

        expect(market_attributes).to have_key(:county)
        expect(market_attributes[:county]).to be_a String 

        expect(market_attributes).to have_key(:state)
        expect(market_attributes[:state]).to be_a String 

        expect(market_attributes).to have_key(:zip)
        expect(market_attributes[:zip]).to be_a String 

        expect(market_attributes).to have_key(:lat)
        expect(market_attributes[:lat]).to be_a String 

        expect(market_attributes).to have_key(:lon)
        expect(market_attributes[:lon]).to be_a String 

        expect(market_attributes).to have_key(:vendor_count)
        expect(market_attributes[:vendor_count]).to be_an Integer
      end
    end
  end

  describe "'/markets/:id'" do
    describe "happy path" do
      it "can get one market by its id" do
        id = create(:market).id

        get "/api/v0/markets/#{id}"
        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to have_key(:data)
        expect(json[:data]).to be_a Hash

        market = json[:data]

        expect(market).to have_key(:id)
        expect(market[:id]).to be_a String

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a Hash

        market_attributes = market[:attributes]

        expect(market_attributes).to have_key(:name)
        expect(market_attributes[:name]).to be_a String 

        expect(market_attributes).to have_key(:street)
        expect(market_attributes[:street]).to be_a String 

        expect(market_attributes).to have_key(:city)
        expect(market_attributes[:city]).to be_a String 

        expect(market_attributes).to have_key(:county)
        expect(market_attributes[:county]).to be_a String 

        expect(market_attributes).to have_key(:state)
        expect(market_attributes[:state]).to be_a String 

        expect(market_attributes).to have_key(:zip)
        expect(market_attributes[:zip]).to be_a String 

        expect(market_attributes).to have_key(:lat)
        expect(market_attributes[:lat]).to be_a String 

        expect(market_attributes).to have_key(:lon)
        expect(market_attributes[:lon]).to be_a String 

        expect(market_attributes).to have_key(:vendor_count)
        expect(market_attributes[:vendor_count]).to be_an Integer
      end
    end

    describe "sad path" do
      it "returns a 404 error if searching for an invalid Market id" do
        get "/api/v0/markets/123123123123"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to have_key(:errors)
        expect(json[:errors]).to be_an Array
        expect(json[:errors].count).to eq(1)
        
        expect(json[:errors][0]).to be_a Hash
        expect(json[:errors][0]).to have_key(:detail)
        expect(json[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
      end
    end
  end
end
