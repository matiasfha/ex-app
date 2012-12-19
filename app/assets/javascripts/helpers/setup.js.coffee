class (namespace 'Dandoo').Setup
	resetForm:  =>
		$.fn.reset = ->
			$(this).each () ->
				this.reset 
	ajaxSetup: =>
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache: true

	constructor: ->
		@resetForm()
		@ajaxSetup()