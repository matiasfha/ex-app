class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_must_revalidate
  before_filter :set_user_language

  private
  def set_user_language
  	if user_signed_in?
   		I18n.locale = current_user.language
   	else
   		I18n.locale = 'es'
   	end
  end

  def set_must_revalidate
    response.headers["Cache-Control"] = "must-revalidate"
  end
end
