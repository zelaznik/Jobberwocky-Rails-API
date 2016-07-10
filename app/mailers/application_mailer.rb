class ApplicationMailer < ActionMailer::Base
  default from: "support@#{ENV['FRONT_END_URL']}"
  layout 'mailer'
end
