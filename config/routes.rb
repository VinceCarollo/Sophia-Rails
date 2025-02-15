Rails.application.routes.draw do
  root 'welcome#index'
  namespace :api do
    namespace :v1 do
      post '/speech', to: 'speech#create'
      post '/login', to: 'login#create'

      resources :clients, only: [:show, :update, :create, :destroy, :index]

      resources :caretakers, only: [:create, :update, :destroy, :show, :index]

      resources :lists, only: [:index, :show, :create, :update, :destroy] do
        resources :tasks, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
