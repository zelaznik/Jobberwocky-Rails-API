class RegistrationsController < ApplicationController
  skip_before_action :authenticate_request, except: [:destroy]

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
      session = user.generate_authentication_token!
      UserMailer.welcome_email(user).deliver_now
      render json: session, status: 200
    end
  end

  def destroy
    current_user.destroy!
    head 204
  end

  def request_new_password
    email = request_params[:email]
    email_confirmation = request_params[:email_confirmation]
    if email != email_confirmation
      render json: { error: "Email addresses don't match."}, status: 422
    else
      user = User.find_by(email: email)
      user.send_reset_password_instructions unless user.nil?
      render json: {
        success: "You should receive an email with your password reset instructions."
      }, status: 200
    end
  end

  def assign_new_password
  end

  private
  def request_params
    params.require(:user).permit(:email, :email_confirmation)
  end

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
