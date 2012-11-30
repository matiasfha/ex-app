#encoding utf-8
DandooDev::Application.routes.draw do

  #Para metadatos generales.. retornan JSON
  match 'metadata/get_states/:id'   => 'metadata#get_states'
  match 'metadata/get_communes/:id' => 'metadata#get_communes'
  match 'metadata/get_cities/:id'   => 'metadata#get_cities'

  root :to => 'home#index'


  devise_for :users, :controllers => { :registrations => "registrations"}
  devise_scope :user do
    get '/register'                 => 'registrations#new'
    delete '/logout'                => 'devise/sessions#destroy'
    get '/logout'                   => 'devise/sessions#destroy'
  end

  match '/empresas' => 'registrations#create', :via => :post

  resources :users, :only => [:show,:update]

  
  resources :resources, :only => [:create,:show,:index,:destroy]
  match 'recursos/mas_votados(/:page)' => 'resources#mas_votados',:via => :get
  match 'recursos/mas_comentados(/:page)' => 'resources#mas_comentados',:via => :get
  match 'recursos/nuevos(/:page)' => 'resources#nuevos',:via => :get
  
  #resources :comments, :only => [:create,:show]
  #match '/comments/:pid/:cid' => 'comments#destroy', :via => :delete
  #match '/votos/:pid/:valor' => 'votos#create', :via => :post

  match 'auth/:provider/callback'  => 'authentications#new'
  resources :authentications, :only => [:index,:create,:destroy]
  match '/feedback' => 'metadata#feedback', :via => :post
end
