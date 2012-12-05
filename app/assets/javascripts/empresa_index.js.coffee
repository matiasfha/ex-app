require.config
	shim:
		'modernizr':
			exports:'Modernizr'
		'underscore-min':
			exports:'_'
		'backbone-min':
			deps:['underscore-min']
			exports:'Backbone'
		'File/FileAPI.min':
			exports:'FileAPI'
		'jquery.serializeObject':['jquery']
		'jquery.numeric':['jquery']
		'jquery.rutvalidate':['jquery']
		'jquery.isotope':['jquery']

require [
	'jquery'
	'underscore-min'
	'backbone-min'
	'domReady'
	'jquery.numeric'
	'File/FileAPI.min'
	'jquery.serializeObject'
	'jquery.rutvalidate'
	'jquery.isotope'
],($,_,Backbone,domReady,N,F,S,R,I) ->
	domReady () ->
		

		$.fn.reset = ->
			$(this).each () ->
				this.reset()
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache:false
		
		$('.numeric').numeric()
		$('div.mensajes').delay(2000).fadeOut()

		#Metodos
		previewAvatar = (e) ->
			file = FileAPI.getFiles $('#user_avatar')
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
								MAX_WIDTH = 120
								MAX_HEIGHT = 150
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
								$('div.avatar').html _this
								
						
						
						
					when 'progress'
						$('div.avatar').animate {opacity: evt.loaded/evt.total * 100}
					else
						html = '<span>No se puede mostrar un preview del nuevo Avatar, tu Navegador no lo soporta.<br />Aún así podrá actualizarse sin problemas</span>'
						$('div.avatar').html html

		togglePassword = (e) ->
			type = 'password'
			if $(e.currentTarget).is(':checked')
				type = 'text'
			ps = $('#user_password').clone()
			ps.attr('type',type)
			psc = $('#user_password_confirmation').clone()
			psc.attr('type',type)
			$('#user_password').after(ps).remove()
			$('#user_password_confirmation').after(psc).remove()

		checkPaso1 = (e) ->
			#obtener todos los inputs dentro de #paso1 y buscar si hay alguno vacio
			error = false
			inputs = $('#paso1 :text[value=""],#paso1 :password[value=""]')
			if inputs.length > 0
				error = true
				$(i).addClass('error') for i in inputs
			select = $('#paso1 select option:selected')	
			if select.val()==""
				$('#paso1 select').addClass('error')
				error = true
			if $('#user_password').val().length < 6
				error = true
				$('#user_password,#user_password_confirmation').addClass('error')

			if $('#user_password').val()!=$('#user_password_confirmation').val()
				error = true
				$('#user_password,#user_password_confirmation').addClass('error')

			if !$('#user_empresa_rut_empresa').rutValidate($('#user_empresa_dv_empresa').val())
					$('#user_empresa_rut_empresa,#user_empresa_dv_empresa').addClass 'error'
					error = true

			if !error #no hay errores
				$('#paso1').fadeOut 'slow',(e) ->
					$('#paso2').fadeIn('slow')
					$('ul.pasos li:nth-child(2) div').removeClass('paso-off').addClass('paso-on')
		
		checkPaso2 = (e) ->
			#obtener todos los inputs dentro de #paso2 y buscar si hay alguno vacio
			error = false
			inputs = $('#paso2 :text[value=""]')
			if inputs.length > 0
				error = true
				$(i).addClass('error') for i in inputs
			select = $('#paso2 #user_empresa_representante_tipo_telefono option:selected')	
			if select.val()==""
				$('#paso2 #user_empresa_representante_tipo_telefono').addClass('error')
				error = true
			select = $('#paso2 #user_country_id option:selected')	
			if select.val()==""
				$('#paso2 #user_country_id').addClass('error')
				error = true
			if !$('#condiciones').is(':checked')
				error = true
				alert('Debe aceptar las condiciones de uso para continuar')
			if !error			
				$('#recaptcha_modal').fadeIn()

		#Eventos
		$('.error').live 'focus',  (e) ->
			$(this).removeClass 'error'
		$('#user_avatar').on 'change', previewAvatar
		$('#show').on 'click',togglePassword
		$('#go_paso2').on 'click',checkPaso1
		$('#go_paso3').on 'click',checkPaso2
		$('#recaptcha_response_field').on 'keypress', (e) ->
			if e.which==13
				$('#new_user').submit()

		$('#ir_paso1').click (e) ->
			if !$('#paso1').is(':visible') && $('#paso2').is(':visible')
				$('#paso2').fadeOut 'slow',(e) ->
					$('#paso1').fadeIn 'slow'
					$('ul.pasos li:nth-child(2) div').removeClass('paso-on').addClass('paso-off')

		$('#ir_paso2').click (e) ->
			if !$('#paso2').is(':visible')
				$('#paso1').fadeOut 'slow',() ->
					$('#paso2').fadeIn 'slow'
					$('ul.pasos li:nth-child(2) div').removeClass('paso-off').addClass('paso-on')
				# $('#paso1').animate
				# 	left:'5%'
				# 	opacity:0
				# ,'slow', () ->
				# 	$('#paso2').animate
				# 		right:'34%'
				# 		width:'show'	
				# 	,'slow'
				

		