class VideosController < ApplicationController

  load_and_authorize_resource :except => [:create_or_update_video]
  
  def create_or_update_video
  	if params[:id]
  		#updateamos
  		@video = Video.find(params[:id])
  	else
  		#creamos
  		@video = Video.new
  	end
  	if params[:name]
  		@video.name = params[:name]
    end
  	if params[:description]
  		@video.description = params[:description]
    end
  	if params[:character_duration]
  		@video.character_duration = params[:character_duration]
    end
    if params[:keywords_question]
      @video.keywords_question = params[:keywords_question]
    end
    if params[:correct_keyword]
      @video.correct_keyword = params[:correct_keyword]
    end
    if params[:keywords]
      @video.keywords = params[:keywords]
    end
    @video.update_attributes(params[:video])
    @video.save
    #agregamos las preguntas
    i = 0
    Integer(params[:questions_ammount]).times do 
    	i += 1
    	name = (params['value_'+(i).to_s])
    	Question.create(:video_id => @video.id, :name => name)
    end

    return redirect_to admin_video_path(@video.id)
  end

  def show
    @video = Video.find(params[:id])
    @uev = current_user.user_experiment_videos.where(:video_id => @video.id)
    length = 4
    @key = (0...length).map{97.+(rand(25)).chr}.join
    gon.random_chars = @key
    gon.key_options = @video.keywords.split(', ')

  end

end
