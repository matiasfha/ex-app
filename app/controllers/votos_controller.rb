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
				suma 			 = 0
				resource.votos.each do |v|
					suma+=v.valor
				end
				promedio = (total!=0)? suma/total : 0
			else
				#Ya fue votado se debe actualizar el voto
				voto.valor 	= params[:valor]
				voto.save
				total 		= resource.votos.count
				suma 		= 0
				resource.votos.each do |v|
					suma+=v.valor
				end
				promedio = (total!=0)? suma/total : 0
			end
			render :json => {:result => true,:total => resource.votos.count,:promedio => promedio}
		else
			render :json => {:result => false}
		end
	end


end