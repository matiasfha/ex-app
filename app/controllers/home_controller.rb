class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]
  def index
  	@pictures = Picture.order_by([[:created_at,:desc]]).page(params[:page]).per(6)  	
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
  	@pictures = Picture.order_by([[:created_at,:desc]]).page(params[:page]).per(12)    
  end
end
