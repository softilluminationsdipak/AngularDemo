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

  # root 'welcome#index' ## For Angular
  get '/signup/thanks'      => 'welcome#thanks',        as: :thanks
  get '/signup'             => 'welcome#plans',         as: :plans
  
  devise_for :users, controllers: {sessions: 'users/sessions'}, skip: [:registrations, :passwords, :sessions]
  as :user do
    get     'signup/:plan',   to: 'users/registrations#new',        as: :new_registration
    post    'signup',         to: "users/registrations#create",     as: :registration
    get     'sessions/new',   to: 'users/sessions#new',             as: :new_session
    post    'sessions/new',   to: 'users/sessions#create',          as: :session
    delete  'logout',         to: 'users/sessions#destroy',         as: :destroy_session
    get     'logout',         to: 'users/sessions#destroy'
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
