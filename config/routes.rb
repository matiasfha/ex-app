DandooDev::Application.routes.draw do
  

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  
  #Para metadatos generales.. retornan JSON
  match 'metadata/get_states/:id'   => 'metadata#get_states'
  match 'metadata/get_communes/:id' => 'metadata#get_communes'
  match 'metadata/get_cities/:id'   => 'metadata#get_cities'
  
  match 'metadata/populares(/:page)' => 'resources#populares', :via => :get 
  match 'metadata/valorados(/:page)' => 'resources#valorados', :via => :get 

  match 'metadata/subidas(/:page)' => 'resources#subidas', :via => :get
  match 'metadata/last_resource' => 'resources#last_resource', :via => :get
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => 'home#landpage'
  # root :to => 'home#prelaunch'
  #Rutas para secciones
  match 'populares(/:page)' => 'home#populares', :via => :get 
  match 'imagenes_populares(/:page)' => 'home#imagenes_populares', :via => :get
  match 'videos_populares(/:page)' => 'home#videos_populares', :via => :get

  match 'vistos(/:page)' => 'home#vistos', :via => :get
  match 'imagenes_vistos(/:page)' => 'home#imagenes_vistas', :via => :get
  match 'videos_vistos(/:page)' => 'home#videos_vistos', :via => :get

  match 'todos_index(/:page)' => 'home#todos_index', :via => :get
  match 'imagenes_index(/:page)' => 'home#imagenes_index', :via => :get
  match 'videos_index(/:page)' => 'home#videos_index', :via => :get

  match 'nuevos(/:page)' => 'home#nuevos', :via => :get
  match 'imagenes_nuevos(/:page)' => 'home#imagenes_nuevas', :via => :get
  match 'videos_nuevos(/:page)' => 'home#videos_nuevos', :via => :get
  
  devise_for :users, :controllers => { :registrations => "registrations"}
  devise_scope :user do 
    get '/register'                 => 'devise/registrations#new'
    delete '/logout'                => 'devise/session#destroy'
    get '/user/complete_registration/:user' => 'registrations#completar'
    put '/user/complete_registration' => 'registrations#finalizar'
  end
  resources :users, :only => [:show,:index]
  resources :resources, :only => [:create,:show,:index]
  
  match '/resources/add_like' => 'resources#add_like', :via => :post
  match '/resources/remove_like' => 'resources#remove_like', :via => :post
  match '/resources/visor/:id' => 'resources#visor', :via => :get
  
  resources :comments, :only => [:create,:show]
  match '/comments/:pid/:cid' => 'comments#destroy', :via => :delete
  
  match '/votos/:pid/:valor' => 'votos#create', :via => :post

  match 'auth/:provider/callback'  => 'authentications#new'

  resources :authentications, :only => [:index,:create,:destroy]
  resources :emails, :only => [:create] 
  
end
