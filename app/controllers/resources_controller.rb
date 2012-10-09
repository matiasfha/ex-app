class ResourcesController < ApplicationController
  before_filter :authenticate_user!, :only => [:add_like,:create]
  
  def index
    resources = Resource.order_by([[:created_at,:desc]]).page(params[:page])
    render :partial => "listado",:locals => {:resources => resources}
  end
  def show
  	@resource = Resource.find(params[:id])
    @resource.num_views+=1;
    @resource.save
    @comentarios = @resource.comments
    @comentario = Comment.new
  end

  def visor
    @resource = Resource.find(params[:id])
    @resource.num_views+=1;
    @resource.save
    @comentarios = @resource.comments
    @comentario = Comment.new
    render :partial => 'home/visor'
  end

  def add_like
  	@resource = Resource.find(params[:id])
  	if @resource.likers.where(:id => current_user.id).count == 0
  		@resource.likers << current_user
      @resource.num_likes+=1;
      @resource.save
      render :json => @resource.likers.count
  	else
      render :json => -1
    end
	  
  end

  def remove_like
    @resource = Resource.find(params[:id])
    if @resource.likers.where(:id => current_user.id).count > 0
      @resource.likers.delete current_user
      @resource.num_likes-=1
      @resource.save
      render :json => @resource.likers.count
    else
      render :json => -1
    end
  end

  def create
    if params[:resource][:url]
      res = OEmbed::Providers.get(params[:resource][:url])
      params[:resource][:thumbnail] = res.thumbnail_url
      params[:resource][:url] = res.request_url
      params[:resource][:type] = 'video'
      params[:resource][:html] = res.html
      params[:resource][:provider] = res.provider_url.split(".")[1]
    end
    current_user.resources << Resource.new(params[:resource])
    render :json => {:result => current_user.save, :resource => current_user.resources.last}
  end

  

  def mas_votadas
    @resources = User.resource_votados(current_user.id,params[:page])
    render :partial => "resources/listado"
  end


  def subidas
    @resources = current_user.resources.desc(:created_at).page(params[:page])
    render :partial => "resources/listado"
  end

  def last_resource
    @resource = current_user.resources.last
    render :partial => "resources/resource"
  end
end
