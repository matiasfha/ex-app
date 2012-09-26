class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
  	picture = Picture.find(params[:comment][:picture_id])
  	if !picture.nil?
	  	@comment = Comment.new
	  	@comment.contenido = params[:comment][:contenido]
	  	@comment.user_id = current_user.id
	  	picture.comments << @comment 
	  	if picture.save
	  		render :partial => 'new_comment', :content_type => 'text/html',:locals =>{picture_id:picture.id}
      else
        render :json => false
	  	end
	end
  end

  def show
  	picture = Picture.find(params[:id])
  	if !picture.nil?
  		@comentarios = picture.comments.order_by([[:created_at,:desc]])
  		render :partial => 'list_comments', :content_type => 'text/html', :locals => {comentarios:picture.comments,picture_id:params[:id]}
  	end

  end

  def destroy
    picture = Picture.find(params[:pid])
    if !picture.nil?
      comentario = picture.comments.find(params[:cid])
      if !comentario.nil?
        comentario.delete
        render :json => {:result => true,:cid => params[:cid]}
      else
        render :json => false
      end
    else
      render :json => false
    end

  end
end
