class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    auth = request.env["omniauth.auth"]
    abort(auth.to_s)
    current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
    flash[:notice] = "Autenticacion exitosa."
    redirect_to authentications_url
  end

  def create_omniauth
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if !user
      #vemos si existe algun usuario con ese email y le agregamos los datos
      user = User.find_by_email(auth['info']['email']) || User.find_by_username(auth['info']['nickname'])
      if !user
        if auth["provider"]=='facebook'
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
        end
        #generamos un ref
        ref = user.generate_ref
        Ref.create(:value => ref, :user_id => user.id)
        sign_in('user', user)
        sign_out('user')
        session[:user_id] = user_id
        #enviamos un correo
        UserMailer.welcome_facebook(user).deliver
        user.random_pass = nil
        user.save
        #redirigimos al home
        gflash :notice => "Se te ha enviado un email con tu contrase&ntilde;a temporal"
        if session[:current_page]!=nil
          return redirect_to session[:current_page]
        else
          return redirect_to home_path
        end

      else
        #linkeamos su cuenta
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        if auth['info']['name']!=nil
          user.name = auth['info']['name']
        end
        user.active = true
        user.save
        sign_in('user', user)
        sign_out('user')
        session[:user_id] = user.id
        gflash :success => "Has Ingresado!"
        if session[:current_page]!=nil
          return redirect_to session[:current_page]
        else
          return redirect_to home_path
        end
      end
    else
      #lo logueamos
      if auth['info']['name']!=nil&&auth['info']['name']==user.email
        user.name = auth['info']['name']
        user.save
      end
      sign_in('user', user)
      sign_out('user')
      session[:user_id] = user.id
      gflash :success => "Has Ingresado!"
      if session[:current_page]!=nil
          return redirect_to session[:current_page]
        else
          return redirect_to home_path
        end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Relacion destruida correctamente."
    redirect_to authentications_url
  end
end
