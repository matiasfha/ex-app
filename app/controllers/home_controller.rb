class HomeController < ApplicationController
  def index
  	#@resources = Resource.mas_votadas(params[:page])
  	@resources = Resource.all.page(params[:page])
  end

end