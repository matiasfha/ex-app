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
    # if Picture.count > 6
     @pictures = Picture.order_by([[:created_at,:desc]]).page(page)
    # else
    #   @pictures = Picture.all.order_by([[:created_at,:desc]])
    # end
  end
end
