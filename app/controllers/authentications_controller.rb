class AuthenticationsController < ApplicationController
  def index
  	@authentications = current_user.authentications if current_user
  end

  def create
    auth = request.env['omniauth.auth']
    if auth['provider'] == 'facebook'
      omniauth['extra']['user_hash']['email'] ? email =  omniauth['extra']['user_hash']['email'] : email = ''
      omniauth['extra']['user_hash']['first_name'] ? name =  omniauth['extra']['user_hash']['first_name'] : name = ''
      omniauth['extra']['user_hash']['last_name'] ? apellido =  omniauth['extra']['user_hash']['last_name'] : apellido = ''
      omniauth['extra']['user_hash']['id'] ?  uid =  omniauth['extra']['user_hash']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    else
      #Twitter
      email = ''   
      apellido = ''
      omniauth['user_info']['name'] ? name =  omniauth['user_info']['name'] : name = ''
      omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    end


    if provider!= '' && uid!=''
      if !user_signed_in?
        authentication = Authentication.where(:uid => uid,:provider => provider).first    
        if authentication 
          flash[:notice] = "Ingreso correcto via "+provider.capitalize+'.'
          sign_in_and_redirect(:user,auth.user)
        else
          if email !=''
            user = User.where(:email => email).first 
            if user 
              user.authentications << Authentication.new(:provider => provider, :uid => uid)
              flash[:notice] = "Ingreso via "+provider.capitalize+" se a agregado a tu cuenta."
              sign_in_and_redirect(:user,user)
            else
              #CREAR NUEVO USUARIO 
            end
          else
            flash[:error] = provider.capitalize+ "No se puede utilizar para registrarse en Dandoo.tv o se ha ingresado un email no valido."
            redirect_to new_user_session_path
          end
      end  
    else
      #Ya esta logeado
      authentication = Authentication.where(:uid => uid,:provider => provider).first    
      if !authentication
        current_user.authentications << Authentication.new(:provider => provider, :uid => uid)
        flash[:notice] = "Ingreso via "+provider.capitalize+" se a agregado a tu cuenta."
        redirect_to authentications_path
      else
        flash[:notice] = provider.capitalize+" ya existe en tu cuenta".
        redirect_to authentications_path
    end

  end

  def destroy
  	@authentication = current_user.authentications.find(params[:id])
  	@authentication.destroy
  	flash[:notice] = t(:signed_out)
  	redirect_to root_url
  end

  
end
