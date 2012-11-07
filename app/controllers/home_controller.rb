class HomeController < ApplicationController
  # before_filter :authenticate_user!, :only => [:videos_index]
  def index
  	@resources = Resource.mas_votadas(params[:page])
  end

  def prelaunch
    @email = Email.new
    @email.ip = request.remote_ip
  	render :layout => nil
  end
end
