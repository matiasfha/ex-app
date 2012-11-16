class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
  	@user = User.find(params[:id])
  	@resource = Resource.new
  end

  def update
    @user = User.find(params[:user][:id])
    @user.update(params[:user])
    @user.gender_id = params[:user][:gender]
    @user.civil_statu_id = params[:user][:civil_statu]
    @user.country_id = params[:user][:country]
    @user.state_id = params[:user][:state]
    @user.commune_id =  params[:user][:commune]
    @user.city_id =  params[:user][:city]
    if @user.save
      render :json => {:success => params[:user]}
    else
      render :json => {:success => false}
    end
  end
end
