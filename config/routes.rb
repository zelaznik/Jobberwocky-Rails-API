Jobberwocky::Application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  devise_for :users, skip: [:passwords, :registrations], :controllers => {
    omniauth_callbacks: "omniauth_callbacks",
    registrations: "registrations",
    sessions: 'sessions'
  }

  get "/current_user", to: "sessions#show"
  post "/users", to: "registrations#create"
  delete "/users", to: "registrations#destroy"
  post "users/request_new_password", to: "users#request_new_password"
  post "users/assign_new_password", to: "users#assign_new_password"

end
