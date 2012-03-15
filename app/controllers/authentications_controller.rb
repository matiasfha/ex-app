class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    auth = request.env["rack.auth"]
    abort(auth.to_s)
    current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
    flash[:notice] = "Autenticacion exitosa."
    redirect_to authentications_url
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Relacion destruida correctamente."
    redirect_to authentications_url
  end
end
