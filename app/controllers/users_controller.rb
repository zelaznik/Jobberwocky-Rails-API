class UsersController < ApplicationController
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
end
