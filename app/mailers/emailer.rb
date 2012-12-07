class Emailer < ActionMailer::Base
	def feedback_email(autor, from, comentario)
		@comentario = comentario
		mail(:to => 'matias@dandoo.tv',
			:subject => "Feedback [#{autor}]",
			:from =>  from
		)
	end
end
