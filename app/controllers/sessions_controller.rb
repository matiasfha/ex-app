class SessionsController < ApplicationController
  
  def new

  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Has Ingresado!"
    else
      flash.now.alert = "Email o contrase&ntilde;a inv&aacute;lida"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Has cerrado sesi&oacute;n!"
  end

end
