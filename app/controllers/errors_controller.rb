class ErrorsController < ApplicationController
  skip_before_filter :authenticate_request
  def not_found
    render json: {error: "Route not found"}, status: 404
  end
end
