class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@authentications = current_user.authentications if current_user
  end

  def crear_usuario(nickname,name,apellidos,email,avatar,bio,provider,uid)
    password = Devise.friendly_token.first(7)
    user = User.new(:email => email, :password => password,
      :password_confirmation => password,:nombre => name,
      :apellidos => apellidos,:nickname => nickname,
      :bio => bio)
    user.avatar_remote_url avatar
    user.save
    user.authentications << Authentication.new(:provider => provider, :uid => uid)
    user.save
    flash[:notice] = t "mensajes.ingreso.success"
    sign_in :user, user 
    redirect_to "/user/complete_registration/#{user.id}"
  end

  def create
    auth = request.env['omniauth.auth']
    

    provider = auth['provider'] || ""
    uid      = auth['uid'] || ""
    if provider == 'twitter'
      nickname = auth['info']['nickname'] || ""
      name     = auth['info']['name'].split(' ',2).first || ""
      apellidos= auth['info']['name'].split(' ',2).last || ""
      email    = Faker::Internet.free_email
      avatar   = auth['info']['image'] || ""
      bio      = auth['info']['description'] || ""
    elsif provider == 'facebook'
      nickname = auth['info']['nickname'] || ""
      name     = auth['extra']['raw_info']['first_name']+" "+auth['extra']['raw_info']['middle_name'] || ""
      email    = auth['info']['email'] || Faker::Internet.free_email
      apellidos= auth['info']['last_name'] || ""
      avatar   = auth['info']['image'] || ""
      bio      = ''
    else
      flash[:notice]=t 'mensajes.ingreso.provider_fail'
    end

    if provider && uid 
      if !user_signed_in? #Si no esta logeado ya
        #Buscar Authentication
        authentication = Authentication.where(:provider => provider, :uid => uid).first 
        if authentication #Existe la Authentication
          #Logeo exitoso
          flash[:notice] = t 'mensajes.ingreso.success',:provider=> provider.capitalize
          sign_in_and_redirect(:user,authentication.user)
        else #No existe la authentication
          
          #Si tiene email, buscar dicho email para saber si el user ya existe
          if email!=""
            user = User.where(:email => email).first 
            if user #EL usuario existe.. agrego la autentificacion y login
              user.authentications << Authentication.new(:provider => provider, :uid => uid)
              user.save
              flash[:notice] = t "mensajes.ingreso.success"
              sign_in :user, user 
              redirect_to root_path
            else
              #Se debe crear el usuario
              crear_usuario(nickname,name,apellidos,email,avatar,bio,provider,uid)
            end
          else
            #Crear el usuario
            crear_usuario(nickname,name,apellidos,email,avatar,bio,provider,uid)
          end
        end
      else
        #Asignar Authentication ya que esta logrado
        authentication = Authentication.where(:provider => provider, :uid => uid).first 
        if !authentication
          current_user.authentications << Authentication.new(:provider => provider, :uid => uid)
          flash[:notice] = t 'mensajes.ingreso.auth_success', :provider => provider.capitalize
          redirect_to root_path
        else
          flash[:error] = t "mensajes.ingreso.provider_exists",:provider => provider.capitalize
          redirect_to root_path
        end
      end
    else
      flash[:error] = t "mensajes.ingreso.no_provider"
      redirect_to root_path
    end
  end

  def destroy
  	@authentication = current_user.authentications.find(params[:id])
  	@authentication.destroy
  	flash[:notice] = t(:signed_out)
  	redirect_to root_url
  end

  
end
