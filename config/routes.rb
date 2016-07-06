Jobberwocky::Application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  devise_for :users, :controllers => {
    omniauth_callbacks: "omniauth_callbacks",
    sessions: 'sessions', registrations: 'registrations'
  }
end
