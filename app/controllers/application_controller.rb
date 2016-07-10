class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  before_action :authenticate_request, except: [:preflight, :cors_preflight_check, :cors_set_access_control_headers]

  respond_to :json

  def preflight
    render nothing: true
  end

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || "*"
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin,Content-Type,X-Auth-Token,Authorization'
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || ""
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin,Content-Type,X-Auth-Token,Authorization'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def current_user
    @current_user ||= User.find_by auth_token: request.headers['Authorization']
  end

  def authenticate_request
    if current_user.nil?
      render json: { error: 'authentication failed' }, status: 401
    end
  end
end
