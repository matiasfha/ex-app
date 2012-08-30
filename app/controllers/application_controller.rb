class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery
  helper_method :current_user



  rescue_from CanCan::AccessDenied do |exception|
    gflash :error => "No tienes permiso para acceder a esto"
    redirect_to home_url
  end

  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  
end
