class (namespace 'Dandoo').Feedback extends Backbone.View
	el:$('body')
	events:
		'click #feedback-panel #tab':	'showHidePanel'
		'submit #new_feedback':		'enviarFeedback'
	
		
	showHidePanel: (e)->
		if $(e.currentTarget).hasClass 'active'
			right = '-245px'
		else
			right = '134px';
		$('#feedback-panel').animate({right:right})
		$(e.currentTarget).toggleClass 'active'
	
	enviarFeedback: (e) ->
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

					