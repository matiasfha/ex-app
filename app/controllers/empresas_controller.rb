class EmpresasController < ApplicationController
	layout  'empresa'

	def new
		if user_signed_in?
			redirect_to root_path
		end
		if @user.nil?
			@user = User.new 
			@user.empresa = Empresa.new
			@user.empresa.representante = Representante.new
		end
	end

	def create
		if !verify_recaptcha
			flash.delete :recaptcha_error
			flash[:error] = t :captcha_error
			@user = User.new params[:user]
			@user.build_empresa params[:user][:empresa]
			@user.empresa.build_representante  params[:user][:empresa][:representante]
			render :new
			# redirect_to :action => :new, :params => params
		else
			@user = User.new params[:user]
			@user.build_empresa params[:user][:empresa]
			@user.empresa.build_representante  params[:user][:empresa][:representante]
			if @user.save
				sign_in :user,@user
				render :bienvenido
			else
				errores = []
				@user.errors.each do |k,v| 
					errores<<"#{k} #{v}"
				end
				flash[:error] = errores
				render :new
			end
		end
	end

	def  update
	end

	def destroy
	end

	#Despliega un mensaje de bienvenida
	def bienvenido
	end

	def login
		@user = User.new
		render :layout => 'application'
	end
end