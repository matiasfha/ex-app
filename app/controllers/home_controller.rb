class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]
  def index
  	@pictures = Picture.mas_votadas(params[:page])
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
    @pictures = Picture.mas_votadas(params[:page])
  end

  def populares
    @pictures = Picture.mas_populares(params[:page])
  end


  def vistas
    @pictures = Picture.mas_vistas(params[:page])
  end

  private

  
end
