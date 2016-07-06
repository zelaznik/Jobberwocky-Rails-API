class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def preflight
    render nothing: true
  end

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = ENV['FRONT_END_URL']
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, X-Auth-Token , Authorization'
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

end
