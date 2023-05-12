Rails.application.routes.draw do
  resources :roles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do
    collection do
      post :sign_up
      post :verify_otp
      post :resent_otp
    end
  end
  post "/auth/login", to: "authentication#login"
  get "/*a", to: "application#not_found"
end
