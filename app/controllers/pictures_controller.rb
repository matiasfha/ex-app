class PicturesController < ApplicationController
  before_filter :authenticate_user!, :only => [:add_like,:create]
  
  def index
    pictures = Picture.order_by([[:created_at,:desc]]).page(params[:page])
    render :partial => "home/listado_imagenes",:locals => {:pictures => pictures}
  end
  def show
  	@picture = Picture.find(params[:id])
    @picture.num_views+=1;
    @picture.save
    @comentarios = @picture.comments
    @comentario = Comment.new
  end

  def add_like
  	@picture = Picture.find(params[:id])
  	if @picture.likers.where(:id => User.first.id).count == 0
  		@picture.likers << current_user
      @picture.num_likes+=1;
      @picture.save
      render :json => @picture.likers.count
  	else
      render :json => -1
    end
	  
  end

  def create
    current_user.pictures << Picture.new(params[:picture])
    render :json => {:result => current_user.save, :picture => current_user.pictures.last}
  end

  

  def mas_votadas
    @pictures = User.imagenes_votadas(current_user.id,params[:page])
    render :partial => "home/listado_imagenes"
  end

  def subidas
    @pictures = current_user.pictures.desc(:created_at).page(params[:page])
    render :partial => "home/listado_imagenes"
  end

  def last_picture
    @picture = current.user.pictures.last
    render :partial => "pictures/picture"
  end
end
