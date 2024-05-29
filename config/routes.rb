Rails.application.routes.draw do
  devise_for :users, controllers: {
                       registrations: "users/registrations",
                     }

  # Translation endpoint
  get "/translate", to: "translations#translate"

  # Routes for authenticated users
  authenticate :user do
    resources :collections, except: [:index, :show] do
      resources :items, except: [:show] do
        resources :comments, only: [:create, :destroy]
        resources :likes, only: [:create, :destroy]
      end
    end

    # Move these actions inside the existing resources block
    resources :collections, only: [:new, :create, :edit, :update, :destroy]

    # Profile route
    get "profile/:id", to: "users#show", as: "user_profile"
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
      member do
        patch :block
        patch :unblock
        patch :add_admin_role
        patch :remove_admin_role
      end
    end
    resources :topics, except: [:show], module: "admin"
    resources :tags, except: [:show], module: "admin"
  end

  # Reveal health status
  get "/up", to: "rails/health#show", as: :rails_health_check

  # Root path
  root "users#index"
end
