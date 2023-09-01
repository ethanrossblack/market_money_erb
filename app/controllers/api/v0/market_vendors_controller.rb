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
      if e.message.include?("blank")
        render json: {"errors": [ {"detail": e.message}]}, status: 400
      elsif e.message.include?("association")
        render json: {"errors": [ {"detail": e.message}]}, status: 422
      else
        render json: { "errors": ["detail": e.message] }, status: :not_found
      end
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by!(market_id: market_vendor_params[:market_id], vendor_id: market_vendor_params[:vendor_id])
    MarketVendor.delete(market_vendor)
  end

  private
    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end
end
