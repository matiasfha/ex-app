class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]
  def index
  	get_pictures params[:page]
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
    get_pictures params[:page]
  end

  def populares
    @pictures = Picture.mas_populares
  end

  def votadas
    @pictures = Picture.mas_votadas
  end

  def vistas
    @pictures = Picture.mas_vistas
  end

  private

  def get_pictures(page)
    @pictures = Picture.order_by([[:created_at,:desc]]).page(page)
  end
end
