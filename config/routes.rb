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
    get '/admin/dashboard' => 'admin/admin#dashboard', as: :admin_dashboard
    namespace 'admin', as: 'admin' do
      resources :accounts
      #resources :subscription_plans
      #resources :subscriptions
      #resources :subscription_discounts
      
      #resources :subscription_affiliates
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
    resources :patients do
      member do
        put 'toggle_active_status'
        get 'add_family_member_for'
      end

      resources :patient_cases do
        resources :patient_visits do
          collection do
            post :diagnosis_chosen
          end
          member do
            put :pull_from_case
            put :push_to_case
            get :diagnoses 
          end
          resources :patient_visit_details
        end
      end            
    end

    resources :appointments do
      collection do
        get :day_at_glance
        get :week_at_glance        
      end
    end
  
    resources :procedure_codes do
      collection do
        get :import
        post :type_code_selected
      end
    end
  end

  resources :patients
  
  resources :providers do 
    collection do
      post 'checkUniqueSignName'
    end
  end

  resources :letters do
    collection do
      post 'checkUniqueSignName'
      get 'new_import'
      post 'import'      
    end
  end
  
  resources :insurance_carriers do
    collection do
      post 'checkUniqueSignName'
    end
  end

  resources :attorneys do
    collection do
      post 'checkUniqueSignName'
    end
  end

  resources :referrers do
    collection do
      post 'checkUniqueSignName'
    end
  end
  
  resources :diagnosis_codes do
    collection do
      get   :import
      post  :import_data
      get   :report
      post  :generate_report
    end
  end

  resources :accounts do
    collection do
      get :plan
      post :plan
      get :cancel
      post :cancel
      get :billing
    end
  end
  
  resources :rooms
  root 'welcome#home'

end
