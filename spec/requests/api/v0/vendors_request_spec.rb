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

  describe "POST '/vendors'" do
    it "can create a new vendor" do
      vendor_params = {
                        "name": "Buzzy Bees",
                        "description": "local honey and wax products",
                        "contact_name": "Berly Couwer",
                        "contact_phone": "8389928383",
                        "credit_accepted": false
                      }
      headers = {"CONTENT_TYPE": "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      
      # Verify that the endpoint actually created a new vendor resource
      new_vendor = Vendor.last
      expect(new_vendor.name).to eq(vendor_params[:name])
      expect(new_vendor.description).to eq(vendor_params[:description])
      expect(new_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(new_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(new_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])

      # Verify that the endpoint returned a successful creation response
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      # Verify that the response is formatted correctly
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

      # Verify that the response contains the attributes of the new Vendor resource
      attributes = vendor[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes).to have_key(:description)
      expect(attributes).to have_key(:contact_name)
      expect(attributes).to have_key(:contact_phone)
      expect(attributes).to have_key(:credit_accepted)
      
      expect(attributes[:name]).to eq(vendor_params[:name])
      expect(attributes[:description]).to eq(vendor_params[:description])
      expect(attributes[:contact_name]).to eq(vendor_params[:contact_name])
      expect(attributes[:contact_phone]).to eq(vendor_params[:contact_phone])
      expect(attributes[:credit_accepted]).to eq(vendor_params[:credit_accepted])
    end
  end
end
