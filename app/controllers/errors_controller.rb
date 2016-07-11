class ErrorsController < ApplicationController
  skip_before_filter :authenticate_request
  def not_found
    render json: {
      method: request.method,
      url: request.url
    }, status: 404
  end
end
