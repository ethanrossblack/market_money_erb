class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_not_found_response(exception)
    hash = { "errors": ["detail": exception.message] }
    render json: hash, status: :not_found
  end
end
