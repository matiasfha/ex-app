class RegistrationsController < Devise::RegistrationsController
	#Permite completar el registro de usuario
	def completar
		@user = User.find(params[:id])
	end

	#Permite finalizar el registro de usuario actualizando sus datos
	def finalizar

		vacios = params[:user].reject {|k,v| !v.blank? }
		if vacios.size > 0 #Hay datos vacios generar el mensaje de error
			@error_messages = Hash.new
			vacios.each do |k,v|
				@error_messages[k] = "#{k} No puede estar vacio"
			end
			@user = User.find(params[:user][:id])
			render :action => "completar", :params => {:id => params[:id]}
		else
			@user = User.find(params[:user][:id])
			if @user.update_attributes(params[:user])
				flash[:notice] = t(:welcome)
				redirect_to root_url
			else
				format.html {render :action => "completar", :params => {:id => params[:id]}}
			end
		end
	end

	def create
		if !verify_recaptcha
			flash.delete :recaptcha_error
			build_resource
			resource.valid?
			resource.errors.add(:base,t(:captcha_error))
			clean_up_passwords(resource)
			respond_with_navigational(resource) { render :new }
		else
			flash.delete :recaptcha_error
			super
		end
	end

	protected

	def after_sign_up_path_for(resource)
		"/user/complete_registration/#{resource.id}"
	end
end
