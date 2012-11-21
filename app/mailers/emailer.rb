class Emailer < ActionMailer::Base
	def feedback_email(autor, from, comentario)
		@comentario = comentario
		mail(:to => 'matiasfh@gmail.com',
			:subject => "Feedback [#{autor}]",
			:from =>  from
		)
	end
end
