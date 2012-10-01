DandooDev::Application.routes.draw do
  

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  

  # ActiveAdmin.routes(self)
  # devise_for :admin_users, ActiveAdmin::Devise.config
  
  #Para metadatos generales.. retornan JSON
  match 'metadata/get_states/:id'   => 'metadata#get_states'
  match 'metadata/get_communes/:id' => 'metadata#get_communes'
  match 'metadata/get_cities/:id'   => 'metadata#get_cities'
  match 'metadata/mas_votadas(/:page)' => 'pictures#mas_votadas', :via => :get
  match 'metadata/subidas(/:page)' => 'pictures#subidas', :via => :get
  match 'metadata/last_picture' => 'pictures#last_picture', :via => :get
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => 'home#landpage'
  #Rutas para secciones
  match 'mas_populares(/:page)' => 'home#populares', :via => :get
  match 'mas_vistas(/:page)' => 'home#vistas', :via => :get
  match 'mas_votadas(/:page)' => 'home#index', :via => :get
  #Paginacion resultados para el home y secciones
  
  # match 'mas_populares/:page' => 'home#populares', :via => :get
  # match 'mas_vistas/:page' => 'home#vistas', :via => :get

  devise_for :users, :controllers => { :registrations => "registrations"}
  devise_scope :user do 
    get '/register'                 => 'devise/registrations#new'
    delete '/logout'                => 'devise/session#destroy'
    get '/user/complete_registration/:id' => 'registrations#completar'
    put '/user/complete_registration' => 'registrations#finalizar'
  end
  resources :users, :only => [:show,:index]
  resources :pictures, :only => [:create,:show,:index]
  
  match '/pictures/add_like' => 'pictures#add_like', :via => :post

  
  resources :comments, :only => [:create,:show]
  match '/comments/:pid/:cid' => 'comments#destroy', :via => :delete
  
  match '/votos/:pid/:valor' => 'votos#create', :via => :post

  match 'auth/:provider/callback'  => 'authentications#create'
  resources :authentications, :only => [:index,:create,:destroy]
   
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
  #

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
