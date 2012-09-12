class CommentsController < ApplicationController
  def create
  	picture = Picture.find(params[:comment][:picture_id])
  	if !picture.nil?
	  	@comment = Comment.new
	  	@comment.contenido = params[:comment][:contenido]
	  	@comment.user_id = current_user.id
	  	picture.comments << @comment 
	  	if picture.save
	  		render :partial => 'new_comment', :content_type => 'text/html'
	  	end
	end
  end

  def show
  	picture = Picture.find(params[:id])
  	if !picture.nil?
  		@comentarios = picture.comments
  		render :partial => 'list_comments', :content_type => 'text/html'
  	end

  end
end
