class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end
  
  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    begin
      valid_params?(params)
      results = search_results(params)
      render json: MarketSerializer.new(results)
    rescue ActiveRecord::StatementInvalid => e
      render json: {"errors": [ {"detail": e.message}]}, status: 422
    end
  end

  private

  def valid_params?(params)
    if params.has_key?(:state)
      true
    elsif params.has_key?(:name) && !params.has_key?(:state&&:city)
      true
    else
      raise ActiveRecord::StatementInvalid.new
    end
  end

  def search_params
    params.permit(:name, :state, :city)
  end

  def search_results(params)
    if params.has_key?(:state) && !params.has_key?(:name) && !params.has_key?(:city)
      Market.where(
        "state ILIKE :state",
        { state: "%#{params[:state]}%" }
      )
    elsif params.has_key?(:state) && !params.has_key?(:name) && params.has_key?(:city)
      Market.where(
        "state ILIKE :state AND city ILIKE :city",
        { state: "%#{params[:state]}%", city: "%#{params[:city]}%" }
      )
    elsif params.has_key?(:state) && params.has_key?(:name) && !params.has_key?(:city)
      Market.where(
        "state ILIKE :state AND name ILIKE :name", 
        { state: "%#{params[:state]}%", name: "%#{params[:name]}%" }
      )
    elsif !params.has_key?(:state) && params.has_key?(:name) && !params.has_key?(:city)
      Market.where(
        "name ILIKE :name",
        { name: "%#{params[:name]}%" }
      )
    elsif params.has_key?(:state) && params.has_key?(:name) && params.has_key?(:city)
      Market.where(
        "state ILIKE :state AND name ILIKE :name AND city ILIKE :city", 
        { state: "%#{params[:state]}%", name: "%#{params[:name]}%", city: "%#{params[:city]}%" }
      )
    end
  end
end
