Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :registrations, only: [:create]
      
      resources :sessions, only: [:create]
      delete '/logout/:auth_token' => 'sessions#logout'
      get '/current_user' => 'sessions#current_user'
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #get "/*path" => redirect("/?goto=%{path}")

  constraints subdomain: AppConfig['admin_subdomain'] do
    get '/' => 'subscription_admin#index', as: :admin_dashboard
    namespace 'subscription_admin', path: 'admin', as: 'admin' do
      resources :subscription_plans
      resources :subscriptions
      resources :subscription_discounts
      resources :accounts
      resources :subscription_affiliates
    end
  end

  # root 'welcome#index' ## For Angular
  get '/signup/thanks'      => 'welcome#thanks',        as: :thanks
  get '/signup'             => 'welcome#plans',         as: :plans
  get '/dashboard'          => 'base#dashboard',        as: :user_dashboard

  devise_for :users, 
    controllers: {
      sessions: 'users/sessions', 
      confirmations: 'users/confirmations'
  }, skip: [:registrations, :sessions, :passwords]
  as :user do
    get     'signup/:plan',   to: 'users/registrations#new',        as: :new_registration
    post    'signup',         to: "users/registrations#create",     as: :registration

    get     'sessions/new',   to: 'users/sessions#new',             as: :new_session
    post    'sessions/new',   to: 'users/sessions#create',          as: :session
    delete  'logout',         to: 'users/sessions#destroy',         as: :destroy_session
    get     'logout',         to: 'users/sessions#destroy'

    post    'users/password',      to: 'users/passwords#create',     as: :user_password
    get     'users/password/new',  to: 'users/passwords#new',        as: :new_user_password
    get     'users/password/edit', to: 'users/passwords#edit',       as: :edit_user_password
    patch   'users/password',      to: 'users/passwords#update'
    put     'users/password',      to: 'users/passwords#update'

  end

  ## 1. Clinic - Main
  resources :clinics do
    resources :patients
  end

  resources :patients
  
  resources :providers do 
    collection do
      post 'checkUniqueSignName'
    end
  end
  
  
  root 'welcome#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
