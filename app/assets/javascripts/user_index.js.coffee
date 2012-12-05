require.config
	shim:
		'modernizr':
			exports:'Modernizr'
		'File/FileAPI.min':
			exports:'FileAPI'
		'jquery.serializeObject':['jquery']
		'jquery.numeric':['jquery']
		'jquery.rutvalidate':['jquery']
		'jquery.isotope':['jquery']
		'jquery-ui-1.9.2.custom.min':['jquery']


require [
	'jquery'
	'domReady'
	'jquery.numeric'
	'File/FileAPI.min'
	'jquery.serializeObject'
	'jquery.rutvalidate'
	'jquery.isotope'
	'jquery-ui-1.9.2.custom.min'
],($,domReady,N,F,S,R,I,UI) ->
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
		$('.date').datepicker
			firstDay:1
			monthNames:['Enero','Febrero','Marzo','Abril','Mayo','Junio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
			monthNamesShort:['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']
			dayNames:['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sabado']
			dayNamesMin:['Do','Lu','Ma','Mi','Ju','Vi','Sa']
			dayNamesShort:['Dom','Lun','Mar','Mie','Jue','Vie','Sab']
			dateFormat:'dd/mm/yy'
		$('div.mensajes').delay(2000).fadeOut()
		
		

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
								MAX_WIDTH = 168
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
								$('span.cambiarAvatarUsuario').html _this
								$('#user_avatar_tmp').val($('#user_avatar').val())
					when 'progress'
						$('span.cambiarAvatarUsuario').animate {opacity: evt.loaded/evt.total * 100}
					else
						html = '<span>No se puede mostrar un preview del nuevo Avatar, tu Navegador no lo soporta.<br />Aún así podrá actualizarse sin problemas</span>'
						$('span.cambiarAvatarUsuario').html html

		checkPaso1 = (e) ->
			#obtener todos los inputs dentro de #paso1 y buscar si hay alguno vacio
			error = false
			inputs = $('#paso1 :text[value=""],#paso1 :password[value=""]')
			if inputs.length > 0
				error = true
				$(i).addClass('error') for i in inputs
			select = $('#paso1 select#country option:selected')	
			if select.val()==""
				$('#paso1 select#country').addClass('error')
				error = true
			
			if !$('#user_usuario_rut').rutValidate($('#user_usuario_dv').val())
					$('#user_usuario_rut,#user_usuario_dv').addClass 'error'
					error = true

			if !error #no hay errores
				$('#paso1').fadeOut 'slow',(e) ->
					$('#paso2').fadeIn('slow')
					$('ul.pasos li:nth-child(2) div').removeClass('paso-on').addClass('paso-off')
			false
		
		checkPaso2 = (e) ->
			#obtener todos los inputs dentro de #paso2 y buscar si hay alguno vacio
			error = false
			nickname = $('#paso2 #user_usuario_nickname')
			bio = $('#user_usuario_bio') 
			if nickname.val().length < 0
				error = true
				nickname.addClass('error')
			if bio.val().length < 0
				error = true
				bio.addClass('error')
			if !error			
				$('#recaptcha_modal').fadeIn()

		#Eventos
		$('.error').live 'focus',  (e) ->
			$(this).removeClass 'error'
		
		$('#user_avatar').on 'change', previewAvatar
		$('#go_paso2').on 'click',checkPaso1

		$('#go_paso3').on 'click',checkPaso2
		$('#recaptcha_response_field').on 'keypress', (e) ->
			if e.which==13
				$('#new_user').submit()

		$('#ir_paso1').click (e) ->
			if !$('#paso1').is(':visible') && $('#paso2').is(':visible')
				$('#paso2').fadeOut 'slow',(e) ->
					$('#paso1').fadeIn 'slow'
					$('ul.pasos li:nth-child(2) div').removeClass('paso-off').addClass('paso-on')

		$('#ir_paso2').click (e) ->
			if !$('#paso2').is(':visible')
				$('#paso1').fadeOut 'slow',() ->
					$('#paso2').fadeIn 'slow'
					$('ul.pasos li:nth-child(2) div').removeClass('paso-on').addClass('paso-off')
