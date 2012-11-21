#Controlador que permite obtener datos generales del sistema
#Como Pais, Ciudad, etc
class MetadataController < ApplicationController
	#Genera un partial con el listado de States (Regiones) asociadas
	#a un pais
	def get_states
		states = State.where(:country_id=>params[:id]).order_by([[:nombre,:asc]]) unless params[:id].blank?
		render :json => states.to_json
	end

	#Genera un partial con el listado de Communes (SubRegiones) asociadas
	#a una Region
	def get_communes
		communes = Commune.where(:state_id=>params[:id]).order_by([[:nombre,:asc]]) unless params[:id].blank?
		render :json => communes.to_json
	end

	#Genera un partial con el listado de Cities (Ciudades) asociadas
	#a una Commune
	def get_cities
		cities = City.where(:commune_id=>params[:id]).order_by([[:nombre,:asc]]) unless params[:id].blank?
		render :json => cities.to_json
	end


	
	require 'resolv'
	def validate_email_domain(email)
	      domain = email.match(/\@(.+)/)[1]
	      Resolv::DNS.open do |dns|
	          @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
	      end
	      @mx.size > 0 ? true : false
	end

	#Recibe el formulario de Feedback y envia un email
	def feedback
		from = params[:email]
		autor = params[:nombre]
		comentario = params[:comentario]
		if validate_email_domain(from)
			if verify_recaptcha
				Emailer.feedback_email(autor,from,comentario).deliver
				render :json => {:success => true}
			else
				render :json => {:success => false, :mensaje => 'recaptcha'}
			end
		else
			render :json => {:success => false, :mensaje => 'email'}		
		end
	end

end