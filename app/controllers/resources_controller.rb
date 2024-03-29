require 'bitly'
class ResourcesController < ApplicationController
	layout :get_layout
	before_filter :authenticate_user!, :only => [:create,:destroy,:subir]
	respond_to :html,:json
	Bitly.use_api_version_3

	def http_referer_uri
	  request.env["HTTP_REFERER"] && URI.parse(request.env["HTTP_REFERER"])
	end

	def refered_from_our_site?
	  if uri = http_referer_uri
	    uri.host == request.host
	  end
	end
	

	def show
		@resource = Resource.find(params[:id])
		session[:last_page] = (refered_from_our_site?)  ? http_referer_uri : root_path
		@comments = @resource.comments.order_by([[:created_at,:desc]]).limit(10).reverse
		bitly = Bitly.new(ENV['BITLY_USER'],ENV['BITLY_KEY']) 
		@orig_url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}resources/#{@resource.id}"
		page_url = bitly.shorten(@orig_url) 
		@shorten_url = page_url.short_url
		
		@user = User.find(@resource.user_id)
		if stale?(:etag => [@resource,@comments,@shorten_url])
			respond_to do |format|
				format.html
				format.json #{render :partial => 'show.json'}
			end
		end
	end

	def render_resources(resources)
		if stale?(:etag => resources)
			respond_with(resources) do |format|
	  			format.html {render :partial => 'resources/listado'}
			end
		end
	end

	def mas_votados
		@resources = Resource.mas_votadas(params[:page])
		render_resources @resources
	end

	def nuevos
		@resources       = Resource.nuevos(current_user,params[:page])
		render_resources @resources
	end

	def mas_comentados
		@resources =  Resource.mas_comentados(params[:page])
		render_resources @resources
	end

	def mis_contenidos
		@resources =  current_user.resources.order_by([[:created_at,:desc]]).page(params[:page])
		render_resources @resources
	end

	def todos
		@resources  =  Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
		render_resources @resources
    	end

	def subir
		@resource = Resource.new
		session[:last_page] = (refered_from_our_site?)  ? http_referer_uri : root_path
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
	    url = res.request_url
	    if not url !~/&/i
	      url = url.split('&')
	      url = url[0]
	    end
	    provider  = res.provider_name.downcase
	    params[:resource][:url] = url
	    if provider == 'youtube'
	    	params[:resource][:url] = "http://www.youtube.com/embed/#{youtube_embed(url)}"
	    end
	    
	    params[:resource][:type] = 'video'
	    
	    params[:resource][:provider] = provider
	    params[:resource][:imagen] = open res.thumbnail_url
	    @res = Resource.new(params[:resource])
	  else
	    @res = Resource.new(params[:resource])
	  end
	  if !@res.valid?
	  		@resource = @res
	  		flash[:error] = @res.errors.full_messages
	  		render :subir, :layout => nil
	   else
	   	current_user.resources << @res
		redirect_to "/mis_contenidos"	
	   end	
	end

	protected
	def get_layout
		if request.xhr? || action_name=='splash'
			nil
		else
			'application'
		end	
	end

	def youtube_embed(youtube_url)
	  if youtube_url[/youtu\.be\/([^\?]*)/]
	    youtube_id = $1
	  else
	    # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
	    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
	    youtube_id = $5
	  end
	end
	
end



