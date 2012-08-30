class StaticController < ApplicationController
  
  #load_and_authorize_resource :except => []

  def home
  	unless current_user
  		return redirect_to log_in_path
  	end
  	length = 5
  	@key = (0...length).map{97.+(rand(25)).chr}.join
  	
  end

  def prerelease
  	return render :layout => nil
  end


end
