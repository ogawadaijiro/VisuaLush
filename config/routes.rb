Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "tops#index"

  resources :users, only: [:new, :create, :show, :edit, :update] do
  end
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :posts do
    resources :comments, only: [:create, :destroy, :update]
    resources :likes, only: [:create, :destroy]
  end
end
