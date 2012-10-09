class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index,:videos_index]
  def index
  	@resources = Resource.mas_votadas(params[:page])
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
    @resources = Resource.mas_votadas(params[:page])
  end

  def videos_index
  end

  def imagenes_index
    @resources = Resource.mas_votadas(params[:page])
    render :partial => "resources/listado"
  end

  def imagenes_populares
    @resources = Resource.mas_populares(params[:page])
    render :partial => "resources/listado"
  end


  def imagenes_vistas
    @resources = Resource.mas_vistas(params[:page])
    render :partial => "resources/listado"
  end

  def imagenes_nuevas
    @resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
    render :partial => "resources/listado"
  end
  
end
