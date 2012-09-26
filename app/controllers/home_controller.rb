class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]
  def index
  	@users = User.all
  	@pictures = Picture.all.order_by.order_by([[:created_at,:desc]])  	
  end

  def prelaunch
  	render :layout => nil
  end

  def landpage
  	@pictures = Picture.all.order_by.order_by([[:created_at,:desc]])   
  end
end
