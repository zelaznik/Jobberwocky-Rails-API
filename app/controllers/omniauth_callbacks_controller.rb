class OmniauthCallbacksController < ApplicationController
  skip_before_action :authenticate_request

  def provides_callback_for(provider)
    user = User.find_for_oauth(env["omniauth.auth"], current_user)

    if user.persisted?
      token = user.generate_authentication_token!
      auth = SessionSerializer.new(token).to_hash
    else
      auth = { user: false }
    end

    payload = auth.to_json
    data = Base64.urlsafe_encode64(payload)
    base_url = "#{ENV['FRONT_END_URL']}"
    base_url = base_url[0...-1] if base_url[-1] == '/'
    redirect_to "#{base_url}/auth_callback?data=#{data}"
  end

  def failure
    render json: { error: params }, status: 500
  end

  [:twitter,:facebook,:github,:google_oauth2].each do |provider|
    define_method(provider) { provides_callback_for(provider) }
  end

  def auth_params
    params.permit(:callback_uri)
  end
end
