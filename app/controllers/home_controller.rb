class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index,:videos_index]
  def index
  	@resources = Resource.mas_votadas(params[:page])
  end

  def prelaunch
    @email = Email.new
    @email.ip = request.remote_ip
  	render :layout => nil
  end

  def landpage
    @resources = Resource.mas_votadas(params[:page])
  end

  #Index 
  def videos_index
    @resources = Resource.mas_votadas(params[:page],'video')
    render :partial => "resources/listado"
  end

  def imagenes_index
    @resources = Resource.mas_votadas(params[:page],'imagen')
    render :partial => "resources/listado"
  end

  def todos_index
    @resources = Resource.mas_votadas(params[:page])
    render :partial => "resources/listado"
  end


  #Popularidad 

  def populares
    @resources = Resource.mas_populares(params[:page])
    render :partial => "resources/listado"
  end

  def imagenes_populares
    @resources = Resource.mas_populares(params[:page],'imagen')
    render :partial => "resources/listado"
  end

  def videos_populares
    @resources = Resource.mas_populares(params[:page],'video')
    render :partial => "resources/listado"
  end

  #Vistas
  def imagenes_vistas
    @resources = Resource.mas_vistas(params[:page],'imagen')
    render :partial => "resources/listado"
  end

  def videos_vistos
    @resources = Resource.mas_vistas(params[:page],'video')
    render :partial => "resources/listado"
  end

  def vistos
    @resources = Resource.mas_vistas(params[:page])
    render :partial => "resources/listado"
  end


  #Nuevos
  def imagenes_nuevas
    @resources = Resource.where(:type => 'imagen').order_by([[:created_at,:desc]]).page(params[:page])
    render :partial => "resources/listado"
  end
  
  def videos_nuevos
    @resources = Resource.where(:type => 'video').order_by([[:created_at,:desc]]).page(params[:page])
    render :partial => "resources/listado"
  end

  def nuevos
    @resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
    render :partial => "resources/listado"
  end
end
