class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    user_email = session_params[:email]
    user_password = session_params[:password]
    user = User.find_by(email: user_email)

    if user && user.valid_password?(user_password)
      user.generate_authentication_token!
      render json: user, serializer: CurrentUserSerializer, status: 200
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    if current_user.nil?
      render json: { errors: "User not found" }, status: 404
    else
      current_user.generate_authentication_token!
      head 204
    end
  end

  def show
    if current_user
      render json: current_user, serializer: CurrentUserSerializer, status: 200
    else
      render json: {}, status: 404
    end
  end

  private
  def session_params
    params.require(:user).permit(:email, :password, :auth_token)
  end
end
