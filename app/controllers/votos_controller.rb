class VotosController < ApplicationController
	before_filter :authenticate_user!

	def create
		resource = Resource.find(params[:pid])
		if !resource.nil?
			resource.rate(:by => current_user,:value => params[:valor].to_i).save
			total = resource.rates_count
			resource.promedio = sprintf '%.2f',resource.rates_average
			resource.save
			render :json => {:result => true,:total => total,:promedio => resource.promedio}
		else
			render :json => {:result => false}
		end
	end


end