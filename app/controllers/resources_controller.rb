class ResourcesController < ApplicationController
  before_filter :authenticate_user!, :only => [:add_like,:create,:destroy]
  respond_to :html, :json
  #Retorna los recursos en vas al tipo (imagen,video,todos)
  #y clasificacion
  def index
    case params[:clasificacion]
    when 'index'
      @resources = Resource.mas_votadas(params[:page],params[:tipo])
      
    when 'populares'
      @resources = Resource.mas_populares(params[:page],params[:tipo])
      
    when 'vistos'
      @resources = Resource.mas_vistas(params[:page],params[:tipo])
      
    when 'nuevos' 
      if params[:tipo]=='todos'
        @resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
      else
        @resources = Resource.where(:type => params[:tipo]).order_by([[:created_at,:desc]]).page(params[:page])
      end
    else
      @resources = Resource.mas_votadas(params[:page])
    end
    respond_with(@resources) do |format|
      format.html {render :partial => "resources/listado"}
      format.json {render :partial => "resources/listado", :formats => [:json]}
    end
  end

  #Despliega informacion para un recurso en especifico
  #Usa el parametro
  def show
  	@resource = Resource.find(params[:id])
    @resource.num_views+=1;
    @resource.save
    
    respond_with(@resource) do |format|
      format.html
      format.json {render :partial => 'resources/item',:formats => [:json]}
    end
  end

  #Permite agregar o eliminar likes desde el recurso
  #identificado por params[:id]
  #la acción de agregar o remover se define
  #en params[:action]
  def like
  	@resource = Resource.find(params[:id])
  	# if @resource.likers.where(:id => current_user.id).count == 0
  		
      if params[:accion] == 'remove'
        @resource.num_likes-=1
        @resource.likers.delete current_user
      else
        @resource.num_likes+=1;
        @resource.likers << current_user
      end
      @resource.save
      render :json => @resource.likers.count
  	# else
   #    render :json => -1
   #  end
	  
  end

  #Crea un nuevo recurso
  #Retorna el recurso creado
  def create
    if params[:resource][:url]
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
    else
      @res = Resource.new(params[:resource])
    end
    current_user.resources << @res
    if !current_user.save
      flash[:error] = "No se pudo crear el nuevo recurso"
    end
    respond_with(@res)
    # respond_with(@res) do |format|
    #   format.html 
    #   format.json {render :json => @res}  
    # end
    # render :json => {:result => current_user.save, :resource => current_user.resources.last,:params =>params[:resource]}
  end

  #Permite eliminar un recurso basado en su id params[:id]
  def destroy
    @resource = Resource.find(params[:id])
    if current_user.id == @resource.user_id
      if !@resource.destroy
        flash[:error] ="No se pudo eliminar el recurso"
      end
      respond_with(@resource) do |format|
        format.html {redirect_to "/users/#{current_user.id}"}
        #format.json {render :json => @resource}
      end
    else
      flash[:error] ="No esta autorizado para eliminar el recurso"
      respond_with(@resource) do |format|
        format.html {redirect_to "/users/#{current_user.id}"}
        format.json {render :json => false}
      end
    end
  end

end
