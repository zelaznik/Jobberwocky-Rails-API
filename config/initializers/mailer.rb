config = Jobberwocky::Application.config
sec = Rails.application.secrets

config.action_mailer.default_url_options = { :host => ENV['API_ROOT_URL'] }
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
    address:                  'smtp.gmail.com',
    port:                     587,
    domain:                   'gmail.com',
    authentication:           'plain',
    enable_starttls_auto:     true,
    user_name:                sec.gmail_username,
    password:                 sec.gmail_password
}
