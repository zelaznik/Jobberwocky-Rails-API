class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  force_ssl if: proc { !Rails.env.development? }
  protect_from_forgery with: :null_session

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def self.provides_callback_for(provider)
    define_method provider do
      callback_uri = params[:callback_uri]
      user = User.find_for_oauth(env["omniauth.auth"], current_user)
      if user.persisted?
        # sign_in user, event: :authentication
        user.generate_authentication_token!
        auth = {
          auth_token: user.auth_token,
          email: user.email, id: user.id
        }
      else
        auth = {user: false}
      end

      redirect_to "#{callback_uri}?#{auth.to_query}"
    end
  end

  [:twitter, :facebook].each do |provider|
    provides_callback_for provider
  end
end
