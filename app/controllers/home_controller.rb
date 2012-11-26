class HomeController < ApplicationController
  def index
  	@email = Email.new
    @email.ip = request.remote_ip
    render :layout => nil
  end

  
end
