class PictureController < ApplicationController
  def show
  	@picture = Picture.find(params[:id])
  end

  def add_like
  	@picture = Picture.find(params[:id])
  	if @picture.likers.where(:id => User.first.id).count == 0
  		@picture.likers << current_user
  	end
	render :json => @picture.likers.count

  end
end
