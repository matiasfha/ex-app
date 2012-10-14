#Controlador que permite obtener datos generales del sistema
#Como Pais, Ciudad, etc
class MetadataController < ApplicationController
	#Genera un partial con el listado de States (Regiones) asociadas
	#a un pais
	def get_states
		states = State.where(:country_id=>params[:id]) unless params[:id].blank?
		render :json => states.to_json
	end

	#Genera un partial con el listado de Communes (SubRegiones) asociadas
	#a una Region
	def get_communes
		communes = Commune.where(:state_id=>params[:id]) unless params[:id].blank?
		render :json => communes.to_json
	end

	#Genera un partial con el listado de Cities (Ciudades) asociadas
	#a una Commune
	def get_cities
		cities = City.where(:commune_id=>params[:id]) unless params[:id].blank?
		render :json => cities.to_json
	end
end