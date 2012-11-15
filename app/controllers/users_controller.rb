class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
  	@user = User.find(params[:id])
  	@resource = Resource.new
    
    @resources = @user.resources.order_by([[:created_at,:desc]]).page(params[:page])
  end

  def user_subidas
  	@user = User.find(params[:id])
  	@resources = @user.resources.order_by([[:created_at,:desc]]).page(params[:page])
  	render :partial => "resources/listado"
  end
end
