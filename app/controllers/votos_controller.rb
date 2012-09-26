class VotosController < ApplicationController
	before_filter :authenticate_user!

	def create
		picture = Picture.find(params[:pid])
		if !picture.nil?
			#Verificar que no se ha realizado el voto
			voto = Voto.where(:user_id => current_user.id, :picture_id => picture.id).first
			if voto.nil?
				#Agregar un nuevo voto
				voto = Voto.new
				voto.valor = params[:valor]
				voto.user_id = current_user.id 
				voto.picture_id = picture.id 
				voto.save
				total = picture.votos.count
				suma = 0
				picture.votos.each do |v|
					suma+=v.valor
				end
				promedio = (total!=0)? suma/total : 0
				render :json => {:result => true,:total => picture.votos.count,:promedio => promedio}
			else
				#Ya fue votado no se puede votar nuevamente
				render :json => {:result => false}
			end

		end
	end
end