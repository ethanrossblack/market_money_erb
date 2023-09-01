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
    require "pry"; binding.pry
    params.permit(:name, :state, :city)
  end

  def search_results(params)
    if params.has_key?(:state) && !params.has_key?(:name) && !params.has_key?(:city)
      Market.where(
        "lower(state) LIKE lower(:state)",
        { state: params[:state] + "%" }
      )
    elsif params.has_key?(:state) && !params.has_key?(:name) && params.has_key?(:city)
      pry
      Market.where(
        "lower(state) LIKE lower(:state) AND lower(city) LIKE lower(:city)",
        { state: "#{params[:state]}%", city: "#{params[:city]}%" }
      )
    elsif params.has_key?(:state) && params.has_key?(:name) && !params.has_key?(:city)
      require "pry"; binding.pry
      Market.where(
        "lower(state) LIKE lower(:state) AND lower(name) LIKE lower(:name)", 
        { state: "#{params[:state]}%", name: params[:name] + "%" }
      )
    elsif !params.has_key?(:state) && params.has_key?(:name) && !params.has_key?(:city)
      Market.where(
        "lower(name) LIKE lower(:name)",
        { name: params[:name] + "%" }
      )
    elsif params.has_key?(:state) && params.has_key?(:name) && params.has_key?(:city)
      Market.where(
        "lower(state) LIKE lower(:state) AND lower(name) LIKE lower(:name) AND lower(city) LIKE lower(:city)", 
        { state: "#{params[:state]}%", name: "#{params[:name]}%", city: "#{params[:city]}%" }
      )
    end
  end

  def sanitize_term(term)
    "%" + term + "%"
  end
end
