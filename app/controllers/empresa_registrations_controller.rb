class EmpresaRegistrationsController < Devise::RegistrationsController
	layout 'layout'
	def index
		
	end

	def new
		@empresa = Empresa.new
	end

	def create
		super
	end

	protected 
		def after_sing_up_path_for(resource)
			redirect_to "empresa/profile"
		end
end
