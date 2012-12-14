class Emailer < ActionMailer::Base
	def feedback_email(autor, from, comentario)
		@comentario = comentario
		mail(:to => 'soporte@dandoo.tv',
			:subject => "Feedback [#{autor}]",
			:from =>  from
		) do |format|
			  format.text { render :text => @comentario}
  			  format.html { render :text => @comentario }
		end
	end
end
