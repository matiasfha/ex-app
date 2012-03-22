class UsersController < ApplicationController

  load_and_authorize_resource :except => [:new, :create]

  def edit
    @user = User.find(params[:id])
    if params[:password_confirmation]
      @password_confirmation = true
    else
      @password_confirmation = false
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    
    if params[:user][:password].blank?
      [:password,:password_confirmation,:current_password].collect{|p| params[:user].delete(p) }
    else
      @user.errors[:base] << "La contrase&ntilde;a ingresada es incorrecta" unless @user.valid_password?(params[:user][:current_password])
    end

    respond_to do |format|
      if @user.errors[:base].empty? and @user.update_attributes(params[:user])
          gflash :success => 'Has modificado tu perfil!'
          return redirect_to home_path
      else
        return render action: "edit"
      end
    end
  end


end
