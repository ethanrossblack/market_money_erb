require "rails_helper"

describe "Vendors API Endpoint" do
  describe "'/vendors/:id'" do
    describe "happy path" do
      it "can get one vendor by its id" do
        id = create(:vendor).id

        get "/api/v0/vendors/#{id}"
        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to have_key(:data)
        expect(json[:data]).to be_a Hash

        vendor = json[:data]

        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a String

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq("vendor")

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a Hash

        attributes = vendor[:attributes]
        expect(attributes).to be_a Hash
        
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a String
        
        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a String
        
        expect(attributes).to have_key(:contact_name)
        expect(attributes[:contact_name]).to be_a String
        
        expect(attributes).to have_key(:contact_phone)
        expect(attributes[:contact_phone]).to be_a String
        
        expect(attributes).to have_key(:credit_accepted)
        expect(attributes[:credit_accepted]).to be_in([true, false])
      end
    end

    describe "sad path" do
      it "returns a 404 error if searching for an invalid Vendor id" do
        get "/api/v0/vendors/123123123123"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to have_key(:errors)
        expect(json[:errors]).to be_an Array
        expect(json[:errors].count).to eq(1)
        
        expect(json[:errors][0]).to be_a Hash
        expect(json[:errors][0]).to have_key(:detail)
        expect(json[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      end
    end
  end
end
