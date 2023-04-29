Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create] do
    collection do
      post :verify_otp
      post :resent_otp
    end
  end
  post "/auth/login", to: "authentication#login"
  get "/*a", to: "application#not_found"
end
