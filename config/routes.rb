#encoding utf-8
DandooDev::Application.routes.draw do

  #Para metadatos generales.. retornan JSON
  match 'metadata/get_states/:id'   => 'metadata#get_states'
  match 'metadata/get_communes/:id' => 'metadata#get_communes'
  match 'metadata/get_cities/:id'   => 'metadata#get_cities'
  match '/feedback' => 'metadata#feedback', :via => :post

  authenticated :user do 
    root :to => 'home#index'
  end
  root :to => 'home#splash'

  match 'ingresar' => 'home#ingresar', :via => :get
  match 'nuevos' => 'home#recursos_nuevos',:via => :get 
  match 'comentados' => 'home#recursos_comentados',:via => :get
  match 'mis_contenidos' => 'home#mis_contenidos', :via => :get
  match 'todos' => 'home#todos', :via => :get

  devise_for :users, :controllers => { :registrations => "registrations",:sessions => 'sessions'}
  devise_scope :user do
    delete '/logout'                => 'devise/sessions#destroy'
    get '/logout'                   => 'devise/sessions#destroy'
    get '/empresas/login'    => 'sessions#new'
  end

  resources :empresas, :only => [:new, :create, :update, :destroy]
  resources :users, :only => [:show,:update]

  
  resources :resources, :only => [:create,:show,:index,:destroy]
  match 'recursos/mas_votados(/:page)' => 'resources#mas_votados',:via => :get
  match 'recursos/mas_comentados(/:page)' => 'resources#mas_comentados',:via => :get
  match 'recursos/nuevos(/:page)' => 'resources#nuevos',:via => :get
  match 'recursos/mis_contenidos(/:page)' => 'resources#nuevos',:via => :get
  match 'recursos/todos(/:page)' => 'resources#todos',:via => :get
  match 'recursos/subir' => 'resources#subir', :via => :get
  
  resources :comments, :only => [:create,:show,:index]
  #match '/comments/:pid/:cid' => 'comments#destroy', :via => :delete
  match '/votos/:pid/:valor' => 'votos#create', :via => :post

  match '/auth/test' => 'authentications#test'
  match '/auth/bienvenido' => 'authentications#bienvenido'
  match 'auth/:provider/callback'  => 'authentications#new'
  resources :authentications, :only => [:index,:create,:destroy]
  match '/feedback' => 'metadata#feedback', :via => :post
end
