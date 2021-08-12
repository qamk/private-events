Rails.application.routes.draw do
  get 'users/show'
  devise_for :users

  root 'events#index'
  get 'profile', to: 'users#show'
  resolve('User') { [:profile] }

  resources :events do
    resources :invites, shallow: true
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
