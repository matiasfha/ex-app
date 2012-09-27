class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]
  def index
  	if Picture.all.count > 0
     @pictures = Picture.order_by([[:created_at,:desc]]).page(params[:page])
    else
      @pictures = Picture.order_by([[:created_at,:desc]])
    end
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
    if Picture.all.count > 0
  	 @pictures = Picture.order_by([[:created_at,:desc]]).page(params[:page])
    else
      @pictures = Picture.order_by([[:created_at,:desc]])
    end
  end
end
