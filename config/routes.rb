Alzheimer::Application.routes.draw do
  
  get "user_filters/update_filter"

  get "user_filters/destroy_filter"

  get "experiments/create_or_update"

  get "questions/update_question"

  get "questions/destroy_question"

  get "videos/create_or_update_video"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :authentications
  resources :sessions
  resources :users

  get "static/home"

  get "sessions/new"

  match "users/:id/edit" => 'users#edit', :as => 'user_edit'
  match "create_or_update_video" => 'videos#create_or_update_video', :as => 'create_or_update_video'
  match "create_or_update" => 'experiments#create_or_update', :as => 'create_or_update'

  get "users/show"

  #ajax
  match 'update_question/:index' => 'questions#update_question', :as => 'update_question'
  match 'destroy_question/:id' => 'questions#destroy_question', :as => 'destroy_question'
  match 'update_video/:index' => 'experiments#update_video', :as => 'update_video'
  match 'destroy_video/:id' => 'experiments#destroy_video', :as => 'destroy_video'
  match 'update_filter/:index' => 'user_filters#update_filter', :as => 'update_filter'
  match 'destroy_filter/:id' => 'user_filters#destroy_filter', :as => 'destroy_filter'

  #videos
  match 'show_video/:uev' => 'videos#show', :as => 'show_video'
  match 'submit_captcha' => 'videos#submit_captcha', :as => 'submit_captcha'

  #automated
  match 'start_todays_experiments/:secret' => 'experiments#start_todays_experiments'

  root :to => 'sessions#new'

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "home" => "static#home", :as => "home"

  match '/auth/:provider/callback' => 'auths#create'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
