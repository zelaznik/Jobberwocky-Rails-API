class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    user_email = session_params[:email]
    user_password = session_params[:password]
    user = User.find_by(email: user_email)

    if user && user.valid_password?(user_password)
      session = user.generate_authentication_token!
      render json: session, status: 200
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    if current_user.nil?
      render json: { errors: "User not found" }, status: 404
    else
      current_session.destroy!
      head 204
    end
  end

  def show
    render json: current_session, status: 200
  end

  private
  def session_params
    params.require(:user).permit(:email, :password, :auth_token)
  end
end
