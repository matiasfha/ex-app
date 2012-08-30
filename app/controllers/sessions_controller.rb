class SessionsController < ApplicationController

	

	def create
		auth = request.env['omniauth.auth']
		user = User.where(:provider => auth['provider'],:uid=>auth['uid']).first || User.create_with_omniauth(auth)
		session[:user_id] = user.id 
		redirect_to "/", :notice => 'Login'

	end

	def destroy
		reset_session
		redirect_to "/", :notice => 'Logout'
	end

	def failure
		redirect_to "/", :alert => "Error: #{params[:message].humanize}"
	end
end
