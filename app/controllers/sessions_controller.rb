class SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  force_ssl if: proc { !Rails.env.development? }

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def create
    user_email = session_params[:email]
    user_password = session_params[:password]
    user = User.find_by(email: user_email)

    if user && user.valid_password?(user_password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      data = {user: {id: user.id, email: user.email, auth_token: user.auth_token}}
      render json: data, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

   def destroy
    user = User.find_by(auth_token: params[:id])
    unless user.nil?
      user.generate_authentication_token!
      user.save!
    end
    head 204
  end

  private
  def session_params
    params.require(:user).permit(:email, :password)
  end
end
