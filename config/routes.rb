Jobberwocky::Application.routes.draw do
  match "*all", to: "application#preflight", via: [:options]

  scope constraints: {format: :json} do
      devise_for :users, skip: [:passwords, :registrations], :controllers => {
      omniauth_callbacks: "omniauth_callbacks",
      registrations: "registrations",
      sessions: 'sessions'
    }

    get "/session", to: "sessions#show"
    post "/users", to: "registrations#create"
    delete "/users", to: "registrations#destroy"
    post "users/request_new_password", to: "registrations#request_new_password"
    post "users/assign_new_password", to: "registrations#assign_new_password"

    resources :users, only: [:index, :show] do
      resources :messages, only: [:index]
    end
  end

  match "*all", to: "errors#not_found", via: :all
end
