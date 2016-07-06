class SessionsController < ApplicationController
  before_action :authenticate_request, except: [:create]

  def new
  end

  def create
    user_email = session_params[:email]
    user_password = session_params[:password]
    user = User.find_by(email: user_email)

    if user && user.valid_password?(user_password)
      user.generate_authentication_token!
      data = {user: {id: user.id, email: user.email, auth_token: user.auth_token}}
      render json: data, status: 200
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
      data = {
        current_user: {
          id: current_user.id, email: current_user.email,
          auth_token: current_user.auth_token
        }
      }
      render json: data, status: 200
    else
      render json: {}, status: 404
    end
  end

  private
  def session_params
    params.require(:user).permit(:email, :password, :auth_token)
  end
end
