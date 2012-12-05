class HomeController < ApplicationController
  def index
  	@resources = Resource.mas_votadas(params[:page])
  end

  def recursos_nuevos
  	@resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
  	render :layout => 'application'
  end

  def recursos_comentados
  	@resources =  Resource.mas_comentados(params[:page])
  	render :layout => 'application'
  end

  def mis_contenidos
    if user_signed_in?
      @resources =  current_user.resources
      render :layout => 'application'
    else 
      redirect_to root_path
    end
  end

  def ingresar
  	if user_signed_in?
  		redirect_to root_path
  	end
  	@back = params[:back] || request.env["HTTP_REFERER"]
  	render :layout => nil
  end

end
