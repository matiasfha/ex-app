class StaticController < ApplicationController
  
  #load_and_authorize_resource :except => []

  def home
  	unless current_user
  		return redirect_to log_in_path
  	end

  end
end
