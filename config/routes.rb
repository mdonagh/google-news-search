Rails.application.routes.draw do
  resources :search_results
  resources :search_terms
  devise_for :users
  root to: 'search_terms#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
