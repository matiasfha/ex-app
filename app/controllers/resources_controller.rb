class ResourcesController < ApplicationController
	layout :get_layout
	before_filter :authenticate_user!, :only => [:create,:destroy,:subir]
	respond_to :html

	

	def show
		@resource = Resource.find(params[:id])
		#@resource.num_views+=1;
		# @resource.save
		session[:last_page] = if(refered_from_our_site?) http_referer_uri || root_path
		@comments = @resource.comments.order_by([[:created_at,:desc]]).limit(10).reverse
	end

	def mas_votados
		@resources = Resource.mas_votadas(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	def nuevos
		@resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	def mas_comentados
		@resources =  Resource.mas_comentados(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	def mis_contenidos
		@resources =  current_user.resources.order_by([[:created_at,:desc]]).page(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	def todos
		@resources  =  Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
    		@nuevos       = Resource.nuevos.count
	end
	def subir
		@resource = Resource.new
		render :layout => nil
	end

	#Crea un nuevo recurso
  #Retorna el recurso creado
  def create
    if !params[:resource][:url].blank?
      u = URI.parse(params[:resource][:url])
      url = params[:resource][:url]
      if !u.scheme
        url = "http://#{url}"
      end

      res = OEmbed::Providers.get(url)
      params[:resource][:thumbnail] = res.thumbnail_url
      url = res.request_url
      if not url !~/&/i
        url = url.split('&')
        url = url[0]
      end
      params[:resource][:url] = url
      params[:resource][:type] = 'video'
      params[:resource][:html] = res.html
      provider  = res.provider_name.downcase
      @res = Resource.new(params[:resource])
      @res.provider = provider
      @res.imagen   = open res.thumbnail_url
    else
      @res = Resource.new(params[:resource])
    end
    current_user.resources << @res
    redirect_to "/mis_contenidos"
    
  end

	protected
	def get_layout
		request.xhr? ? nil : 'application'
	end

	
end