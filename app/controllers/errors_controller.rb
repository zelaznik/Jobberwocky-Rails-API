class ErrorsController < ApplicationController
  skip_before_filter :authenticate_request
  def not_found
    data = {}
    data[request.method] = request.url
    render json: data, status: 404
  end
end
