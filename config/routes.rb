Rails.application.routes.draw do
  devise_for :users

  root 'events#index'
  get 'profile', to: 'users#show'
  resolve('User') { [:profile] } # Allows link_to with a User object to route to profile (singular resource)

  resources :events do
    resources :invites, shallow: true
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
