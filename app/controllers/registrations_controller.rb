class RegistrationsController < ApplicationController
  before_action :authenticate_request, except: [:create]
  force_ssl if: proc { !Rails.env.development? }

  def create
    email = registration_params[:email]
    password = registration_params[:password]
    password_confirmation = registration_params[:password_confirmation]

    if password != password_confirmation
      render json: { errors: "Passwords don't match"}, status: 422
    elsif User.find_by(email: email)
      render json: { errors: "User already exists with that email"}, status: 422
    else
      user = User.create! email: email, password: password
      user.generate_authentication_token!
      render json: user, serializezr: CurrentUserSerializer, status: 200
    end
  end

  def destroy
    current_user.destroy!
    head 204
  end

  private
  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
