class UserFiltersController < ApplicationController
  
  def update_filter
  	@index = params[:index]
    return render :layout => nil
  end

  def destroy_filter
    user_filter = UserFilter.find(params[:id])
    UserFilter.delete(user_filter)
  	return render :nothing => true
  end

end
