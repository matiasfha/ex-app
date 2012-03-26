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
    
    i = 0
    Integer(params[:videos_ammount]).times do 
      i += 1
      video_id = (params['video_'+(i).to_s])
      str = params['start_video_'+(i).to_s][:year]+'-'+params['start_video_'+(i).to_s][:month]+'-'+params['start_video_'+(i).to_s][:day]
      d1 = Time.parse(str)
      str2 = params['end_video_'+(i).to_s][:year]+'-'+params['end_video_'+(i).to_s][:month]+'-'+params['end_video_'+(i).to_s][:day]
      d2 = Time.parse(str2)
      j = 0
      while d1&&d2&&(d1+j.days==d2||d1+j.days<d2)
        date = d1+j.days
        ExperimentVideo.create(:experiment_id => @experiment.id, :video_id => video_id, :play_date => date)
        j += Integer(params['frequency_'+(i).to_s])
      end

    end

    abort('oli')
    i = 0
    

    return redirect_to admin_experiment_path(@experiment.id)
  end
  
  def update_video
    @index = params[:index]
    return render :layout => nil
  end

  def destroy_video
    video = ExperimentVideo.find(params[:id])
    ExperimentVideo.delete(video)
  return render :nothing => true
  end

end
