class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      errors = vendor.errors.full_messages.join(", ")
      render json: { errors: [ detail: "Validation failed: #{errors}"]}, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor)
    else
      errors = vendor.errors.full_messages.join(", ")
      render json: { errors: [ detail: "Validation failed: #{errors}"]}, status: :bad_request
    end
  end

  def destroy
    # calling .find in the delete method to raise an error if trying to delete an improper id
    Vendor.delete(Vendor.find(params[:id]))
    render json: {}, status: :no_content
  end

  private

    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end
