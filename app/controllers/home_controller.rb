class HomeController < ApplicationController
  def index
  	@resources = Resource.mas_votadas(params[:page])
  	if @resources.count == 0
  		@resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
  	end
  end

  def recursos_nuevos
  	@resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
  	render :layout => 'application'
  end

  def recursos_comentados
  	@resources =  Resource.mas_comentados(params[:page])
  	render :layout => 'application'
  end

  def ingresar
  	if user_signed_in?
  		redirect_to root_path
  	end
  	@back = params[:back] || request.env["HTTP_REFERER"]
  	render :layout => nil
  end

end
