class CommentsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json
  def create
  	@resource = Resource.find(params[:comment][:resource_id])
  	if !@resource.nil?
	  	@comment = Comment.new params[:comment]
	  	@resource.comments << @comment 
              @resource.num_comments+=1
	  	if @resource.save
                @comentario = @resource.comments.last
                render :partial => 'new_comment.json'
              else
                    render :json => {success => false, :mensaje => @comentario.errors.full_messages}
	  	end
	end
  end

  def index
    @comments = Resource.find(params[:resource_id]).comments 
    render :partial => 'listado_comments'
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