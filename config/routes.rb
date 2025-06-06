Rails.application.routes.draw do
  get "home/index"
  
  root "home#index"
  resources :users
  resources :cards
  resources :transactions
  post '/login', to: 'auth#login'
  post '/signup', to: 'auth#signup'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :cards, only: [:index, :show, :create, :update, :destroy]
  # post '/cards/:id/buy', to: 'cards#buy', as: 'buy_card'
  resources :cards do
    member do
      post :buy  # Ajoute une route POST pour l'action buy
    end
  end

  # Route pour récupérer les informations de l'utilisateur connecté
  get '/user', to: 'auth#show'

  # Route pour récupérer les transactions de l'utilisateur
  get '/transactions', to: 'transactions#index'



  # Defines the root path route ("/")
  # root "posts#index"
end
