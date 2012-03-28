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
      while d1&&d2&&(d1+j.days==d2||d1+j.days<d2)&&(d1+j.days>@experiment.start_date)&&(d1+j.days<@experiment.end_date)
        date = d1+j.days
        ExperimentVideo.create(:experiment_id => @experiment.id, :video_id => video_id, :play_date => date)
        j += Integer(params['frequency_'+(i).to_s])
      end

    end

    #creamos los filtros
    i = 0
    Integer(params[:filters_ammount]).times do 
      i += 1
      type =  params['type_'+(i).to_s]
      value = params[type+'value_'+(i).to_s]
      #sin ver mucho qué tipo de filtro es, creamos el filtro
      if type=='2'
        value = params['start_age_'+(i).to_s]+','+params['end_age_'+(i).to_s]
      end
      UserFilter.create(:filter_type => type, :value => value, :experiment_id => @experiment.id)
    end

    #filramos a los usuarios
    UserExperiment.delete(@experiment.user_experiments)
    all_users = User.all
    all_users.each do |u|
      if @experiment.do_i_fit_in? u
        @experiment.user_experiments.create(:user_id => u.id)
      end
    end

    #subscibimos a la gente a los videos
    @experiment.experiment_videos.each do |v|
      if v.play_date.to_s==Time.now.to_date.to_s
        @experiment.users.each do |u|
          exists = UserExperimentVideo.find_by_user_id_and_video_id_and_experiment_id(u.id, v.video_id, @experiment.id)
          if !exists
            UserExperimentVideo.create(:experiment_id => @experiment.id, :user_id => u.id, :video_id => v.video_id)
          end
        end
      end
    end


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

  def start_todays_experiments
    unless params[:secret]=='jjuj3kcx9kdn3ndk23jdmxzn23dm'
      return render :nothing => true
    end
    all_active_ex = Experiment.where('start_date < ? AND end_date > ?', Time.now, Time.now)
    all_active_ex.each do |x|
      x.experiment_videos.each do |v|
        if v.play_date.to_s==Time.now.to_date.to_s
          x.users.each do |u|
            exists = UserExperimentVideo.find_by_user_id_and_video_id_and_experiment_id(u.id, v.id, x.id)
            if !exists
              UserExperimentVideo.create(:experiment_id => x.id, :user_id => u.id, :video_id => v.id)
            end
          end
        end
      end
    end
    abort('DONE!')
  end


end
