Rails.application.routes.draw do
  resources :forms
  resources :diagrams
  resources :decisions

  get "up" => "rails/health#show", as: :rails_health_check

  root "diagrams#index"
end
