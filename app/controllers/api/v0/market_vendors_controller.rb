class Api::V0::MarketVendorsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    begin
      market_vendor.save!
      render json: MarketVendorSerializer.new(market_vendor).serialize_json, status: 201
    rescue ActiveRecord::RecordInvalid => e
      if e.message.include?("exist")
        render json: {"errors": [ {"detail": e.message}]}, status: 400
      else
        render json: {"errors": [ {"detail": "Validation failed: Market vendor association between market with market_id=#{market_vendor.market_id} and vendor with vendor_id=#{market_vendor.vendor_id} already exists"}]}, status: 422
      end
    end
  end

  private
    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end
end
