class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
  	@user = User.find(params[:id])
  	@resource = Resource.new
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    
    # render :json => {:success => @user.save()}
    redirect_to "/users/#{@user.id}"
    
  end
end
