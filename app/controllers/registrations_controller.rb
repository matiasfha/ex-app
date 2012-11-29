class RegistrationsController < ApplicationController #Devise::RegistrationsController
	layout 'layout'
	def new
		@empresa = Empresa.new

	end

	

	def create
		if !verify_recaptcha
			# build_resource
			# resource.valid?
			# resource.errors.add(:base,t(:captcha_error))
			# clean_up_passwords(resource)
			render :json => {:success => 'false',:mensaje => 'error_captcha'}
		else
			#super
			@empresa = Empresa.new params[:empresa]
			

			if @empresa.save()
				sign_in :user, @empresa
				render :json => {:success => 'true'}
			else
				render :json => {:success => 'false', :mensaje => @empresa.errors}
			end
			
			
		end
		
	end

	# protected

	def after_sign_up_path_for(resource)
		if resource._type == 'Empresa'
			"/empresa/#{resource.id}"
		else
			super
		end
	end
end
