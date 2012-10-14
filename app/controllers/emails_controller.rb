class EmailsController < ApplicationController
  def new
  	@email = Email.new
  end

  def create
  	@email = Email.where(:email => params[:email][:email]).first
  	if @email.nil?
  		@email = Email.create! params[:email]
  		render :json => {:success => @email.save,:mensaje => 'OK'}
  	else
  		render :json => {:mensaje => 'Ya Existe',:success => 'repeat'}
  	end
  end
end
