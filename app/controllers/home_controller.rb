class HomeController < ApplicationController
  #caches_action :splash
before_filter :check_login!, :only => [:index,:recursos_nuevos,:recursos_comentados,:mis_contenidos,:todos]
  def index
    	@resources = Resource.mas_votadas(params[:page])
      @nuevos       = Resource.nuevos.count
      @votados      = Resource.mas_votadas.count
      @comentados = Resource.mas_comentados.count
  end

  def splash
    render :layout => nil
  end


  def recursos_nuevos
      @resources = Resource.nuevos(params[:page])
      @nuevos       = Resource.nuevos.count
      @votados      = Resource.mas_votadas.count
      @comentados = Resource.mas_comentados.count
      render :layout => 'application'
  end

  def recursos_comentados
  	@resources =  Resource.mas_comentados(params[:page])
      @nuevos       = Resource.nuevos.count
      @votados      = Resource.mas_votadas.count
      @comentados = Resource.mas_comentados.count
  	render :layout => 'application'
  end

  def mis_contenidos
    if user_signed_in?
      @resources =  current_user.resources.order_by([[:created_at,:desc]]).page(params[:page])
      @nuevos       = Resource.nuevos.count
      @votados      = Resource.mas_votadas.count
      @comentados = Resource.mas_comentados.count
      render :layout => 'application'
    else 
      redirect_to root_path
    end
  end

  def todos
    @resources  =  Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
    @nuevos       = Resource.nuevos.count
    @votados      = Resource.mas_votadas.count
      @comentados = Resource.mas_comentados.count
  end

  def ingresar
  	if user_signed_in?
  		redirect_to root_path
  	end
  	@back = params[:back] || request.env["HTTP_REFERER"]
  	render :layout => nil
  end

  private
  def check_login!
    if !user_signed_in?
      redirect_to '/'
    end
  end
end
