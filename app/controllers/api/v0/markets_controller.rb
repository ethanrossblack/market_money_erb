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
      search_results = Market.where("state LIKE ?", "%" + Market.sanitize_sql_like(params[:state]) + "%")
      render json: MarketSerializer.new(search_results)
      
    rescue ActiveRecord::ActiveRecordError => exception
      
    end
  end

  private

  def valid_params?(params)
    if params.has_key?(:state)
      true
    elsif params.has_key?(:name) && !params.has_key(:state&&:city)
      true
    else
      ActiveRecord::ActiveRecordError.new
    end
  end
end
