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
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def imagenes_index
    @resources = Resource.mas_votadas(params[:page],'imagen')
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def todos_index
    @resources = Resource.mas_votadas(params[:page])
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end


  #Popularidad 
  def populares
    @resources = Resource.mas_populares(params[:page])
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def imagenes_populares
    @resources = Resource.mas_populares(params[:page],'imagen')
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def videos_populares
    @resources = Resource.mas_populares(params[:page],'video')
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  #Vistas
  def imagenes_vistas
    @resources = Resource.mas_vistas(params[:page],'imagen')
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def videos_vistos
    @resources = Resource.mas_vistas(params[:page],'video')
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def vistos
    @resources = Resource.mas_vistas(params[:page])
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end


  #Nuevos
  def imagenes_nuevas
    @resources = Resource.where(:type => 'imagen').order_by([[:created_at,:desc]]).page(params[:page])
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end
  
  def videos_nuevos
    @resources = Resource.where(:type => 'video').order_by([[:created_at,:desc]]).page(params[:page])
    respond_to do |format|
      format.html { render :partial => "resources/listado" }
      format.json { render :partial => "resources/listado.json" }
    end
  end

  def nuevos
    @resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
    respond_to do |format|
      format.html {render :partial => "resources/listado"}
      format.json {render :partial => "resources/listado.json"}
    end
  end
end
