class (namespace 'Dandoo').Feedback
	constructor: ->
		@setTab()
		@enviarFeedback()
		
	setTab: =>	
		$('#feedback-panel #tab').on 'click',(e) ->
			if $(e.currentTarget).hasClass 'active'
				right = '-245px'
			else
				right = '134px';
			$('#feedback-panel').animate({right:right})
			$(this).toggleClass 'active'
	
	enviarFeedback: =>
		$('#new_feedback').submit (e) ->
			e.stopPropagation()
			e.preventDefault()
			data = $('#new_feedback').serializeObject()
			html = '<img src="/assets/ajax-loader.gif" class="load"/>'
			container = $('#contentForm')	
			content = container.html()
			container.empty().html html
			$.post  '/feedback',data, (resp) ->
				if resp.success == true
					htm = '<label class="load">Gracias por tus comentarios</label>'
					container.empty().html html
					$('#feedback-panel').delay(3000)
					.animate({right:'-245px'})
					$('#feedback-panel #tab').toggleClass 'active'
					container.html content
					$('#new_feedback').reset()
				else
					container.html content
					$('#new_feedback').reset()
					Recaptcha.reload();
					if resp.mensaje == 'recaptcha'
						$('#recaptcha_response_field').addClass 'error'
					else if resp.mensaje == 'email'
						$('#email').addClass 'error'