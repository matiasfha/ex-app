class UsersController < ApplicationController

  load_and_authorize_resource :except => [:new, :create]

  def edit
    @user = User.find(params[:id])

    if params[:password_confirmation]
      @password_confirmation = true
    else
      @password_confirmation = false
    end

    if params[:not_new]
      @not_new = true
    else
      @not_new = false
    end

    gon.clear
    if @user.birthdate
      gon.birthdate = @user.birthdate
    end

    @interests = Interest.order('name ASC')
    @my_interests = @user.interests

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
    dd = nil
    @user.user_interests.each do |d|
      UserInterest.delete(d.id)
    end
    #checkamos los intereses
    params[:interest].each do |i|
      ii = UserInterest.where(:interest_id => Integer(i.first), :user_id => @user.id)
      if ii.empty?
        #creamos
        if i.last=='1'
          UserInterest.create(:interest_id => Integer(i.first), :user_id => @user.id)
        end
      end
    end
    

    respond_to do |format|
      if simple_captcha_valid? and @user.errors[:base].empty? and @user.update_attributes(params[:user])
          gflash :success => 'Has modificado tu perfil!'
          return redirect_to home_path
      else
        if !simple_captcha_valid?
          gflash :error => 'No has ingresado el ReCaptcha correctamente'
        end
        return render action: "edit"
      end
    end
  end


end
