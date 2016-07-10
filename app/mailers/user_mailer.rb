class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = "#{ENV['FRONT_END_URL']}/login"
    mail to: @user.email, subject: 'Welcome back to my awesome site!'
  end
end
