class PicturesController < ApplicationController
  before_filter :authenticate_user!, :only => [:add_like,:create]
  
  def index
    pictures = Picture.order_by([[:created_at,:desc]]).page(params[:page]).per(6)    
    render :partial => "home/listado_imagenes",:locals => {:pictures => pictures}
  end
  def show
  	@picture = Picture.find(params[:id])
    @comentarios = @picture.comments
    @comentario = Comment.new
  end

  def add_like
  	@picture = Picture.find(params[:id])
  	if @picture.likers.where(:id => User.first.id).count == 0
  		@picture.likers << current_user
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

  def reload_list
    pictures = Picture.where(:user_id => current_user.id).desc(:created_at).page(params[:page]).per(6)    
    render :partial => "home/listado_imagenes",:locals => {:pictures => pictures}
  end
end
