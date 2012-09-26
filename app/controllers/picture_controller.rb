class PictureController < ApplicationController
  before_filter :authenticate_user!, :only => [:add_like]
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
end
