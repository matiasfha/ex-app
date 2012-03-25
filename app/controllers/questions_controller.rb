class QuestionsController < ApplicationController
  def update_question
  	@index = params[:index]
  	return render :layout => nil
  end

  def destroy_question
  	question = Question.find(params[:id])
	Question.delete(question)
	return render :nothing => true
  end

end
