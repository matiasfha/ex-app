class AuthenticationsController < ApplicationController
  def index
  	@authentications = current_user.authentications if current_user
  end

  def create
    require 'json'
  	@auth = request.env['omniauth.auth']
    render :json => @auth, :layout => nil

  # 	authentication = Authentication.where(:provider => auth['provider'],:uid => auth['uid']).first
 	# if authentication #Existe
 	# 	#Solo ingresar al usuario 
 	# 	flash[:notice] = t(:signed_in)
 	# 	sign_in_and_redirect(:user,authentication.user)
 	# elsif current_user #Existe un usuario autentificado
 	# 	#Se agrega la nueva autentificacion
 	# 	current_user.authentications << Authentication.new(:provider => auth['provider'],:uid => auth['uid'])
 	# 	flash[:notice] = t(:success)
 	# 	redirect_to authentications_url
 	# else #No existe dicha autentificacion y no tampoco el usuario logeado
 	# 	#Se crea nuevo usuario y se logea
 	# 	user = create_new_omniauth_user(auth)
 	# 	user.authentications << Authentication.new(:provider => auth['provider'],:uid => auth['uid'])
		# flash[:notice] = t(:welcome) 
		# sign_in_and_redirect(:user,user)		
 	# end
  end

  def destroy
  	@authentication = current_user.authentications.find(params[:id])
  	@authentication.destroy
  	flash[:notice] = t(:signed_out)
  	redirect_to root_url
  end

  def create_new_omniauth_user(auth)
  end
end
