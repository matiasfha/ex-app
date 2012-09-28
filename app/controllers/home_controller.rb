class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]
  def index
  	@pictures = Picture.mas_votadas
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
    @pictures = Picture.mas_votadas
  end

  def populares
    @pictures = Picture.mas_populares
  end


  def vistas
    @pictures = Picture.mas_vistas
  end

  private

  
end
