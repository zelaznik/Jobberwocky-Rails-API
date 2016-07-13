# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  sec = Rails.application.secrets
  config.secret_key = ENV['DEVISE_SECRET_KEY'] || sec.devise_secret_key

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 8..72
  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  config.omniauth(:facebook, sec.facebook_app_id, sec.facebook_app_secret, {
    scope: 'email,public_profile'
  })
  config.omniauth(:google_oauth2, sec.google_client_id, sec.google_client_secret, {
    scope: 'https://www.googleapis.com/auth/userinfo.email'
  })
  config.omniauth(:twitter, sec.twitter_key, sec.twitter_secret, {
    scope: "user:email"
  })
  config.omniauth(:github, sec.github_client_id, sec.github_client_secret, {
    scope: "user:email,user:follow"
  })
end
