class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    render json: VendorSerializer.new(Vendor.create(vendor_params)), status: :created
  end

  private

    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end
