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
				$('#recaptcha_modal').fadeIn()
			false
		
		

		#Eventos
		$('.error').live 'focus',  (e) ->
			$(this).removeClass 'error'
		
		$('#go_paso2').on 'click',checkPaso1

		$('#recaptcha_response_field').on 'keypress', (e) ->
			if e.which==13
				$('#new_user').submit()

		