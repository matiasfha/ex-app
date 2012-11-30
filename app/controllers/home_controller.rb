class HomeController < ApplicationController
  def index
  	#@resources = Resource.mas_votadas(params[:page])
  	@resources = Resource.all.page(params[:page])
  end

  def ingresar
  	if user_signed_in?
  		redirect_to root_path
  	end
  	render :layout => nil
  end

end
