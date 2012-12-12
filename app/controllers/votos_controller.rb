class VotosController < ApplicationController
	before_filter :authenticate_user!

	def create
		resource = Resource.find(params[:pid])
		if !resource.nil?
			voto = Voto.where(:user_id => current_user.id, :resource_id => resource.id).first
			promedio = 0
			if voto.nil?
				#Agregar un nuevo voto
				voto 		     = Voto.new
				voto.valor 		 = params[:valor]
				voto.user_id     = current_user.id 
				voto.resource_id = resource.id 
				voto.save
				total 			 = resource.votos.count
				promedio = Resource.promedio_votos(params[:pid])
			else
				#Ya fue votado se debe actualizar el voto
				voto.valor 	= params[:valor]
				voto.save
				total 		= resource.votos.count
				promedio = Resource.promedio_votos(params[:pid])
			end
			render :json => {:result => true,:total => resource.votos.count,:promedio => promedio}
		else
			render :json => {:result => false}
		end
	end


end