#encoding utf-8
DandooDev::Application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  
  #Para metadatos generales.. retornan JSON
  match 'metadata/get_states/:id'   => 'metadata#get_states'
  match 'metadata/get_communes/:id' => 'metadata#get_communes'
  match 'metadata/get_cities/:id'   => 'metadata#get_cities'
  
  match 'metadata/populares(/:page)' => 'resources#populares', :via => :get 
  match 'metadata/valorados(/:page)' => 'resources#valorados', :via => :get 

  root :to => 'home#index'
  # root :to => 'home#prelaunch'
  
  
  devise_for :users, :controllers => { :registrations => "registrations"}
  devise_scope :user do 
    get '/register'                 => 'devise/registrations#new'
    delete '/logout'                => 'devise/sessions#destroy'
    get '/logout'                   => 'devise/sessions#destroy'
    get '/user/complete_registration/:user' => 'registrations#completar'
    put '/user/complete_registration' => 'registrations#finalizar'
  end
  
  resources :users, :only => [:show,:update]
  
  match 'resources/listado/:clasificacion/:tipo(/:page)' => 'resources#index', :via => :get
  match 'resources/like/:id/:accion' => 'resources#like', :via => :post
  resources :resources, :only => [:create,:show,:index,:destroy]

  match '/resources/listado(/:clasificacion)(/:tipo)(/:page)' => 'resources#index', :via => :get
  match '/resources/listado(/:clasificacion)(/:tipo)(/:page)(/:user_id)' => 'resources#index', :via => :get
  match '/resources/like/:id/:accion' => 'resources#like', :via => :post
  
  resources :comments, :only => [:create,:show]
  match '/comments/:pid/:cid' => 'comments#destroy', :via => :delete
  
  match '/votos/:pid/:valor' => 'votos#create', :via => :post

  match 'auth/:provider/callback'  => 'authentications#new'
  match 'completar' => 'authentications#test'
  resources :authentications, :only => [:index,:create,:destroy]
  resources :emails, :only => [:create] 
  
end
