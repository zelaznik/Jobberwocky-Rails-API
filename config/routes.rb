Jobberwocky::Application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/'  do
    devise_for :users, :controllers => {
      omniauth_callbacks: "omniauth_callbacks",
      sessions: 'sessions', registrations: 'registrations'
    }

    resources :users
  end
end
