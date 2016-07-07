class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  force_ssl if: proc { !Rails.env.development? }
  protect_from_forgery with: :null_session

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def provides_callback_for(provider)
    user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if user.persisted?
      user.generate_authentication_token!
      auth = {
        auth_token: user.auth_token,
        email: user.email, id: user.id,
        name: user.name, image: user.image
      }
    else
      auth = {user: false}
    end

    base_url = "#{ENV['FRONT_END_URL']}/auth_callback"
    redirect_to "#{base_url}?#{auth.to_query}"
  end

  def twitter
    provides_callback_for :twitter
  end

  def facebook
    provides_callback_for :facebook
  end

  def auth_params
    params.permit(:callback_uri)
  end
end
