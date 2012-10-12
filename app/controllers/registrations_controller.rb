class RegistrationsController < Devise::RegistrationsController
	#Permite completar el registro de usuario
	def completar
		render :json => params[:user]
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
