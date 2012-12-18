

class (namespace 'Dandoo.User').Register extends Backbone.View
	el:$('#empresas')
	events:
		'focus .error':		'removeError'
		'click #go_paso2':	'checkPaso1'
		'keypress #recaptcha_response_field':'submitForm'
		'change #file':'previewAvatar'

	initialize: ->
		@render()

	removeError:(e) ->
		$(e.currentTarget).removeClass 'error'

	submitForm: (e)->
		if e.which == 13
			$('#new_user').submit()

	render: =>
		$('.numeric').numeric()
		$('.date').datepicker
			firstDay:1
			monthNames:['Enero','Febrero','Marzo','Abril','Mayo','Junio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
			monthNamesShort:['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']
			dayNames:['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sabado']
			dayNamesMin:['Do','Lu','Ma','Mi','Ju','Vi','Sa']
			dayNamesShort:['Dom','Lun','Mar','Mie','Jue','Vie','Sab']
			dateFormat:'dd/mm/yy'
		$('div.mensajes').delay(2000).fadeOut()
		img = $('<img>').attr('src',$('#user_avatar_tmp').val())
		img.load ->
			$('div.field.imagen .cont').html(img)

	checkPaso1:(e) ->
		#obtener todos los inputs dentro de #paso1 y buscar si hay alguno vacio
		error = false
		inputs = $('#paso1 :text[value=""],#paso1 :password[value=""]')
		if inputs.length > 0
			error = true
			$(i).addClass('error') for i in inputs
		
		
		if !error #no hay errores
			$('#recaptcha_modal').fadeIn()
			$('#recaptcha_response_field').focus();
		false
	previewAvatar: (e) ->
		file = FileAPI.getFiles $('#file')
		file = file[0]
		FileAPI.readAsDataURL file, (evt) ->
			switch evt.type
				when 'load'
					_offscreen = $('<div></div>')
					.css({position:'absolute',left:'-999999px',width:'400px',height:'600px'})
					.appendTo($('body'));
					tmpW = 1
					tmpH = 1
					image = $('<img>')
					image.attr('src',evt.result)
					.load (e) ->
						_this = $(this)
						$(this).appendTo _offscreen
						$(this).imagesLoaded () ->
							tmpW = _this.width()
							tmpH = _this.height()
							_offscreen.remove()
							MAX_WIDTH = 50
							MAX_HEIGHT = 50
							if tmpW > tmpH
								if tmpW > MAX_WIDTH
									tmpH *= MAX_WIDTH / tmpW
									tmpW = MAX_WIDTH
							else
								if tmpH > MAX_HEIGHT
									tmpW *= MAX_HEIGHT / tmpH
									tmpH = MAX_HEIGHT
							_this.attr('width',tmpW)
							_this.attr('height',tmpH)
							$('div.field.imagen .cont').html _this
							$('#user_avatar_tmp').val $('#file').val()

