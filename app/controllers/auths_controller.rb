class AuthsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end
  

  def create
    auth = request.env["omniauth.auth"]
    authentication = Auth.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if !authentication
      #vemos si existe algun usuario con ese email y le agregamos los datos
      user = User.find_by_email(auth['info']['email'])
      if !user
        ref = nil
        # if session[:ref]!=nil
        #   ref = Ref.find_by_value(user.referal)
        #   if ref&&ref.user
        #     u = ref.user
        #     u.sign_ups += 1
        #     u.credits += 1
        #     u.save
        #   end
        # end
        user_id = User.create_with_omniauth(auth, ref)
        user = User.find(user_id)
        #creamos la relación
        Auth.create_with_omniauth(user.id, auth['provider'],auth['uid'])
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
          return redirect_to user_edit_path(user.id)
        end

      else
        #creamos la relación y rellenamos datos vacíos
        Auth.create_with_omniauth(user.id, auth['provider'],auth['uid'])
        if auth["info"]["first_name"]!=nil&&user.first_name==nil&&user.last_name==nil
          user.first_name = auth["info"]["first_name"]
          user.last_name = auth["info"]["last_name"]
        elsif auth["info"]["name"]!=nil&&user.first_name==nil&&user.last_name==nil
          nom = auth["info"]["name"].split(' ')
          if nom[0]!=nil
            user.first_name = nom[0]
          end
          if nom[1]!=nil
            user.last_name = nom[1]
          end
        end
        if auth['info']['image']!=nil&&user.image==nil
          user.image = auth['info']['image']
        end
        if auth["info"]["location"]!=nil&&(user.city==nil||user.country==nil)
          loc = auth["info"]["location"].split(', ')
          city = City.find_by_name(loc[0])
          if city
            user.city = city
          end
          country = Country.find_by_name(loc[1])
          if city
            user.country = country
          end
        end
        if auth['extra']!=nil&&auth['extra']['raw_info']!=nil&&auth['extra']['raw_info']['gender']!=nil
          if auth['extra']['raw_info']['gender']=='male'
            user.sex_id = 2
          elsif auth['extra']['raw_info']['gender']=='female'
            user.sex_id = 1
          end
        end
        user.active = true
        user.save
        session[:user_id] = user.id
        gflash :success => "Has Ingresado!"
        if session[:current_page]!=nil
          return redirect_to session[:current_page]
        else
          return redirect_to user_edit_path(user.id)
        end
      end
    else
      #lo logueamos
      if auth['info']['name']!=nil&&authentication.user&&auth['info']['name']==authentication.user.email
        authentication.user.name = auth['info']['name']
        authentication.user.save
      end
      session[:user_id] = authentication.user.id
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
    redirect_to home_path
  end
end
