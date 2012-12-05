class UsersController < ApplicationController
	before_filter :authenticate_user!, :only => [:destroy]
	layout 'usuario'
	def show
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])

		redirect_to users_path(@user)
	end
end