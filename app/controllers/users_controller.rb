class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
  	@user = User.find(params[:id])
  	@resource = Resource.new
    
    @resources = Array.new
    Voto.where(:user_id => @user.id).each do |v|
      @resources << Resource.find(v.resource_id)
    end
  end

  def user_subidas
  	@user = User.find(params[:id])
  	@resources = @user.resources.order_by([[:created_at,:desc]]).page(params[:page])
  	render :partial => "resources/listado"
  end
end
