class HomeController < ApplicationController
  #caches_action :splash
  before_filter :check_login!, :only => [:index,:recursos_nuevos,:recursos_comentados,:mis_contenidos,:todos]
  layout 'application'

  def index
    	@resources = Resource.mas_votadas(params[:page])
      @seccion   = 'mas_votadas'
      if stale?(:etag => [@resources])
        if request.headers['X-PJAX']
          render :partial => 'listado',:layout => nil
        else
          get_menu_counter()
        end
      end
  end

  def splash
    render :layout => nil
  end


  def recursos_nuevos
      @resources = Resource.nuevos(current_user,params[:page])
      @seccion = 'nuevos'
      if stale?(:etag => [@resources])
        if request.headers['X-PJAX']
          render :partial => 'listado',:layout => nil
        else
          get_menu_counter()
        end
      end
  end

  def recursos_comentados
  	@resources =  Resource.mas_comentados(params[:page])
      @seccion = 'mas_comentados'
      if stale?(:etag => [@resources])
        if request.headers['X-PJAX']
          render :partial => 'listado',:layout => nil
        else
          get_menu_counter()
        end
      end
  end

  def mis_contenidos
    if user_signed_in?
      @resources =  current_user.resources.order_by([[:created_at,:desc]]).page(params[:page])
      @seccion = "mis_contenidos"
      if stale?(:etag => [@resources])
        if request.headers['X-PJAX']
          render :partial => 'listado',:layout => nil
        else
          get_menu_counter()
        end
      end
    else 
      redirect_to root_path
    end
  end

  def todos
    @resources  =  Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
    @seccion = 'todos'
    if stale?(:etag => [@resources])
        if request.headers['X-PJAX']
          render :partial => 'listado',:layout => nil
        else
          get_menu_counter()
        end
      end
  end

  def ingresar
  	if user_signed_in?
  		redirect_to root_path
  	end
  	@back = params[:back] || request.env["HTTP_REFERER"]
  	render :layout => nil
  end

  private
    def get_menu_counter
      @nuevos       = Resource.nuevos(current_user).count
      @votados      = Resource.mas_votadas.count
      @comentados = Resource.mas_comentados.count
    end

    def check_login!
      if !user_signed_in?
        redirect_to '/'
      end
    end
end
