class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
  	@resource = Resource.find(params[:comment][:resource_id])
  	if !@resource.nil?
	  	@comment = Comment.new
	  	@comment.contenido = params[:comment][:contenido]
	  	@comment.user_id = current_user.id
	  	@resource.comments << @comment 
	  	if @resource.save
        @comentario = @resource.comments.last
        respond_to  do |format|
	  		 format.json {render :partial => 'new_comment.json'}
       end
      else
        render :json => false
	  	end
	end
  end

  def show
  	resource = resource.find(params[:id])
  	if !resource.nil?
  		@comentarios = resource.comments.order_by([[:created_at,:desc]])
  		render :partial => 'list_comments', :content_type => 'text/html', :locals => {comentarios:resource.comments,resource_id:params[:id]}
  	end

  end

  def destroy
    resource = Resource.find(params[:pid])
    if !resource.nil?
      comentario = resource.comments.find(params[:cid])
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
