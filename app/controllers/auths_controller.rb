class AuthsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create_omniauth
    auth = request.env["omniauth.auth"]
    abort(auth.to_s)
    current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
    flash[:notice] = "Autenticacion exitosa."
    redirect_to root_path
  end

  def create
    auth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if !authentication
      #vemos si existe algun usuario con ese email y le agregamos los datos
      user = User.find_by_email(auth['info']['email'])
      if !user
        ref = nil
        if session[:ref]!=nil
          ref = Ref.find_by_value(user.referal)
          if ref&&ref.user
            u = ref.user
            u.sign_ups += 1
            u.credits += 1
            u.save
          end
        end
        user_id = User.create_with_omniauth(auth, ref)
        user = User.find(user_id)
        #creamos la relación
        Authentication.create_with_omniauth(user.id, auth['provider'],auth['uid'])
        #generamos un ref
        ref = user.generate_ref
        Ref.create(:value => ref, :user_id => user_id)
        session[:user_id] = user_id
        #enviamos un correo
        #UserMailer.welcome_provider(user, auth['provider']).deliver
        user.random_pass = nil
        user.save
        #redirigimos al home
        gflash :notice => "Se te ha enviado un email con tu contrase&ntilde;a temporal"
        if session[:current_page]!=nil
          return redirect_to session[:current_page]
        else
          return redirect_to root_path
        end

      else
        #creamos la relación
        Authentication.create_with_omniauth(user.id, auth['provider'],auth['uid'])
        if auth['info']['name']!=nil
          user.name = auth['info']['name']
        end
        if auth['info']['image']!=nil
          user.image = auth['info']['image']
        end
        user.active = true
        user.save
        session[:user_id] = user.id
        gflash :success => "Has Ingresado!"
        if session[:current_page]!=nil
          return redirect_to session[:current_page]
        else
          return redirect_to root_path
        end
      end
    else
      #lo logueamos
      if auth['info']['name']!=nil&&authentication.user&&auth['info']['name']==authentication.user.email
        user.name = auth['info']['name']
        user.save
      end
      session[:user_id] = authentication.user.id
      gflash :success => "Has Ingresado!"
      if session[:current_page]!=nil
        return redirect_to session[:current_page]
      else
        return redirect_to root_path
      end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Relacion destruida correctamente."
    redirect_to root_path
  end
end
