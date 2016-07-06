class RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  force_ssl if: proc { !Rails.env.development? }

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def create
    email = registration_params[:email]
    password = registration_params[:password]
    password_confirmation = registration_params[:password_confirmation]

    user = User.find_by(email: email)
    if password != password_confirmation
      render json: { errors: "Passwords don't match" }, status: 422
    elsif user && user.valid_password?(password)
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
  def registration_params
    params.require(:registration).permit(:email, :password)
  end

end
