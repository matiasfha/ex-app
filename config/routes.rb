DandooDev::Application.routes.draw do
  

  
  root :to => 'home#index'
  #Rutas para secciones
  resources :emails, :only => [:create] 
  
end
