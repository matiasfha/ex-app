class SessionsController < ApplicationController
  
  def new
    unless !current_user
      return redirect_to home_path
    end

  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      gflash :success => "Has Ingresado!"
      redirect_to home_path
    else
      user = User.find_by_email(params[:email])
      if user
        gflash :error => "Contrase&ntilde;a equivocada!"
        redirect_to root_url
      else
        user = User.new
        user.email = params[:email]
        user.password = params[:password]
        user.password_confirmation = params[:password]
        user.save
        if user.id
          session[:user_id] = user.id
          gflash :success => "Tu usuario ha sido creado!"
          redirect_to edit_user_path(user.id, :password_confirmation => true)
        else
          gflash :error => "Email inv&aacute;lido!"
          redirect_to root_url
        end
      end
      
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to home_url, :notice => "Has cerrado sesi&oacute;n!"
  end

end
