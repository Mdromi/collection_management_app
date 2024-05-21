Rails.application.routes.draw do
  namespace :admin do
    get 'topics/index'
    get 'topics/new'
    get 'topics/create'
    get 'topics/edit'
    get 'topics/update'
    get 'topics/destroy'
  end
  devise_for :users

  # Routes for authenticated users
  authenticate :user do
    resources :collections, except: [:index, :show] do
      resources :items, except: [:show] do
        resources :comments, only: [:create, :destroy]
        post "like", on: :member
      end
    end
    # Move these actions inside the existing resources block
    resources :collections, only: [:new, :create, :edit, :update, :destroy]
  end

  # Routes for non-authenticated users
  resources :collections, only: [:index, :show] do
    resources :items, only: [:show] do
      resources :comments, only: [:index]
    end
  end

  # Admin dashboard routes
  scope :dashboard do
    get "/", to: "admin/dashboard#index", as: :dashboard
    resources :users, only: [:index, :update, :destroy], module: "admin" do
      patch :block, on: :member
      patch :unblock, on: :member
      patch :add_admin_role, on: :member
      patch :remove_admin_role, on: :member
    end
    resources :topics, except: [:show], module: "admin"
    resources :tags, except: [:show], module: "admin"
  end

  # Reveal health status
  get "/up", to: "rails/health#show", as: :rails_health_check

  # Root path
  root "users#index"
end
