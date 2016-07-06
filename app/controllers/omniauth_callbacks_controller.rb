class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  force_ssl if: proc { !Rails.env.development? }
  protect_from_forgery with: :null_session

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def self.provides_callback_for(provider)
    define_method provider do
      @user = User.find_for_oauth(env["omniauth.auth"], current_user)
      if @user.persisted?
        sign_in @user, event: :authentication
        @user.generate_authentication_token!
        data = {user: {id: @user.id, email: @user.email, auth_token: @user.auth_token}}
        render json: data, status: 200
      else
        render json: { errors: "Failed to authenticate"}, status: 422
      end
    end
  end

  [:twitter, :facebook, :linked_in].each do |provider|
    provides_callback_for provider
  end
end
