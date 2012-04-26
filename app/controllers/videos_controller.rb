class VideosController < ApplicationController

  load_and_authorize_resource :except => [:create_or_update_video]
  
  def create_or_update_video
  	if params[:id]
  		#updateamos
  		@video = Video.find(params[:id])
  	else
  		#creamos
  		@video = Video.new
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
      @video.save
  	end
    @video.update_attributes(params[:video])
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
    @uev = UserExperimentVideo.find(params[:uev])
    @video = @uev.video
    session[:uev] = params[:uev]
    length = 4
    @key = (0...length).map{97.+(rand(25)).chr}.join
    session[:random_chars] = @key
    gon.random_chars = @key
    gon.key_options = @video.keywords.split(', ')
    return render :layout => nil
  end

  def submit_captcha
    uev = UserExperimentVideo.find(session[:uev])
    v = uev.video
    unless session[:random_chars]==params[:captcha_answer]&&v.correct_keyword==params[:keywords_answer]
      #modificamos los datos
      uev.attempts += 1
      uev.save
      gflash :error => 'No has ingresado correctamente el captcha o la respuesta acerca del video. Int&eacute;ntalo de nuevo.'
      return redirect_to show_video_path(session[:uev])
    end
    if uev.succeded==0
      #modificamos los datos
      uev.attempts += 1
      uev.succeded += 1
      uev.save
    end

    gflash :notice => 'Felicitaciones! Has visto un video. Busca otros para ver'
    return redirect_to home_path
  end

end
