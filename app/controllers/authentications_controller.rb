class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index,:destroy]
 layout  'empresa'


  def create
    avatar = params[:user][:avatar_tmp]
    # if avatar.index('facebook')
    #   avatar_tmp = avatar.split('?')
    #   avatar = avatar_tmp[0]+'?type=large'
    # end
    #params[:user][:avatar_tmp] = avatar
    #Check por el email
    u = User.where(:email => params[:user][:email]).first
    if !u.nil?
      #Ya existe el usuario, asociar con la nueva authentificacion
      u.authentications << Authentication.new(:provider => params[:user][:provider], :uid => params[:user][:uid])
      u.save
      sign_in :user, u
      render :bienvenido
    else
      @user = User.new params[:user]
      @user.build_usuario(params[:user][:usuario])
      
      vacios = params[:user].reject {|k,v| !v.blank? }
      vacios.merge params[:user][:usuario].reject {|k,v| !v.blank? }
      if vacios.size > 0 #Hay datos vacios generar el mensaje de error
        @error_messages = Hash.new
        vacios.each do |k,v|
          @error_messages[k] = "#{k} No puede estar vacio"
        end
        flash[:error] = @error_messages
        render :new
      else
        if !avatar.index('C:')
          @user.avatar_remote_url(params[:user][:avatar_tmp])
        else
          @user.avatar = params[:user][:avatar]
        end

        
        password = Devise.friendly_token.first(10)
        @user.password = password
        @user.password_confirmation = password
        if @user.save
          sign_in :user,@user 
          render :bienvenido
        else
          puts @user.errors.full_messages
          flash[:error] =@user.errors.full_messages # 'Ocurrio un error creando el usuario'
          render :new
        end
        
      end
    end
  end

  def crear_usuario(nickname,name,apellidos,email,avatar,bio,nacimiento,provider,uid)
    password = Devise.friendly_token.first(10)
    if provider=='facebook'
      url= avatar.split('?')
      avatar_tmp = url[0]+'?type=square'
    else
      avatar_tmp = avatar.split("_normal")
      avatar_tmp = avatar_tmp[0]+"_normal"+avatar_tmp[1]
      
    end
    @user = User.new(:avatar_tmp => avatar_tmp,
      :email => email,:password => password, :password_confirmation => password)
    @user.build_usuario(:nombre => name, :apellidos => apellidos,
      :nickname => nickname, :bio => bio,:nacimiento => nacimiento)
    @user.avatar_remote_url(avatar)
    @authentication = Authentication.new :uid => uid, :provider => provider
    @user.authentications << @authentication
    @user
  end

  def bienvenido
    if !user_signed_in?
      redirect_to root_path
    end
  end

  

  def new
    auth         = request.env['omniauth.auth']
    @provider     = auth['provider'] || ""
    @uid          = auth['uid'] || ""
    nickname     = auth['info']['nickname'] || ""
    avatar       = auth['info']['image'] || ""
    bio          = ''
    nacimiento   = ''
    if @provider == 'twitter'
      name       = auth['info']['name'].split(' ',2).first || ""
      apellidos  = auth['info']['name'].split(' ',2).last || ""
      email      = ""
      bio        = auth['info']['description']
      
    elsif @provider == 'facebook'
      middle_name = auth['extra']['raw_info']['middle_name'] || ""
      name       = auth['extra']['raw_info']['first_name']+" "+ middle_name
      email      = auth['info']['email'] || ""
      apellidos  = auth['info']['last_name'] || ""
      nacimiento = auth['extra']['raw_info']['birthday']
      if nacimiento.split('/')[1].to_i > 12
        nacimiento = nacimiento.split('/')
        nacimiento = "#{nacimiento[1]}/#{nacimiento[0]}/#{nacimiento[2]}"
      end
    else
      flash[:error]=t 'mensajes.ingreso.provider_fail'
    end
    if @provider && @uid 
      @authentication = Authentication.where(:uid => @uid, :provider => @provider).first
      if @authentication.nil?
        #Buscar un usuario por el email
        @user = User.where(:email => email).first
        if @user.nil?
          #Crear un nuevo usuario
          
          @user = crear_usuario(nickname,name,apellidos,email,avatar,bio,nacimiento,@provider,@uid)
          respond_to do |format|
            format.html { render :action => 'new' }
          end 
        else
          #Asociar al usuario ya existente el provider
          auth = Authentication.new(:provider => @provider, :uid => @uid)
          #Chequear si el usuario ya esta logeado
          if !current_user.nil?
            if current_user.id == @user.id 
              current_user.authentications << auth
              current_user.save 
            else
             #Logear al usuario
             @user.authentications << auth 
             @user.save
             sign_in_and_redirect :user, @user 
            end
          else
            @user.authentications << auth 
            @user.save
            sign_in_and_redirect :user, @user
          end
        end
        
      else
        #La autenticacion ya existe, logear al usuario
        @user = User.find(@authentication.user_id)
        sign_in_and_redirect :user, @user 
      end
    else
      flash[:error] = t "mensajes.ingreso.no_provider"
      redirect_to root_path
    end
  end
  #/////

  

  def destroy
    if current_user._type == 'Usuario'
    	@authentication = current_user.usuario.authentications.find(params[:id])
    	@authentication.destroy
    	flash[:notice] = t(:signed_out)
    end
  	redirect_to root_url
  end

  def failure
    redirect_to root_path, alert: "Autentificacion fallida. Intente nuevamente."
  end
end