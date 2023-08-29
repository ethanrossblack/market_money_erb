require 'rails_helper'

describe "Markets API" do
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
