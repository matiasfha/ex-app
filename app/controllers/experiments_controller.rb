class ExperimentsController < ApplicationController
  def create_or_update

  	if params[:id]
  		#updateamos
  		@experiment = Experiment.find(params[:id])
  	else
  		#creamos
  		@experiment = Experiment.new
  	end
  	if params[:name]
  		@experiment.name = params[:name]
    end
  	if params[:description]
  		@experiment.description = params[:description]
    end
  	if params[:start_date]
  		str = params[:start_date][:year]+'-'+params[:start_date][:month]+'-'+params[:start_date][:day]
  		@experiment.start_date = Time.parse(str)
    end
  	if params[:end_date]
  		str = params[:end_date][:year]+'-'+params[:end_date][:month]+'-'+params[:end_date][:day]
  		@experiment.end_date = Time.parse(str)
    end
    @experiment.save
    
    

    return redirect_to admin_experiments_path
  end
end
