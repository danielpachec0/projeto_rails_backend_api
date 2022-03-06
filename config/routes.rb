Rails.application.routes.draw do
  resources :answers
  resources :questions do
    get :image, on: :member
  end
  resources :formularies
  resources :users
  resources :visits
  post 'authenticate', to: 'authentication#authenticate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
