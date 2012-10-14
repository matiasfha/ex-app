class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  	@users = User.all 
  end

  def show
  	@user = User.find(params[:id])
  	@resources = @user.resources.page(params[:page])
  	@resource = Resource.new
  end
end
