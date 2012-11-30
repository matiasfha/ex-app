class EmpresasController < ApplicationController
	layout  'layout'

	def new
		@empresa = Empresa.new
	end

	def create
		if !verify_recaptcha
		else
			@empresa = Empresa.new params[:empresa]
			if @empresa.save
				sign_in :user,@empresa
			else
			end
		end
	end