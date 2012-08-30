class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :user_loged_in?
  helper_method :correct_user?

  private
  def current_user
  	begin
  		@current_user ||= User.find(session[:user_id]) if session[:user_id] rescue Mongoid::Errors::DocumentNotFound nil
  	end
  end

  def user_loged_in?
  	return true if current_user
  end

  def correct_user?
  	@user = User.find(params[:id])
  	unless current_user == @user 
  		redirect_to "/", :alert => "Acceso denegado"
  	end
  end

  def authenticate_user!
  	if !current_user
  		redirect_to "/", :alert => "Primero ingrese"
  	end
  end
end
