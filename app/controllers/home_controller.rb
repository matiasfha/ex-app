class HomeController < ApplicationController
  def index
	@users = User.all  	
  end

  def prelaunch
  	render :layout => nil
  end
end
