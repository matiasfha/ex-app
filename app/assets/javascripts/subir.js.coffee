require.config
	shim:
		'modernizr':
			exports:'Modernizr'
		'jquery.isotope':['jquery']
		'File/FileAPI.min':
			exports:'FileAPI'
		

require [
	'jquery'
	'modernizr'
	'jquery.isotope'
	'domReady'
	'File/FileAPI.min'
],($,M,isotope,domReady,F) ->
	domReady () ->
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache: false
		$('input[type="radio"]').on 'change',(e) ->
			if $(e.currentTarget).is(':checked') 
				$('.activoRadio').removeClass('activoRadio')
				parent = $(e.currentTarget).parent()
				parent.addClass 'activoRadio'
				if parent.hasClass 'publicaVideo'
					$('div.imagen').hide()
					$('#resource_imagen').val('')
					$('div.preview').empty()
					$('div.video').show()
				else
					$('div.video').hide()
					$('#resource_url').val('')
					$('div.imagen').show()
					

		#Metodos
		previewAvatar = (e) ->
			file = FileAPI.getFiles $('#resource_imagen')
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
								MAX_WIDTH = 150
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
								$('div.preview').html _this
					when 'progress'
						$('div.preview').animate {opacity: evt.loaded/evt.total * 100}
					else
						html = '<span>No se puede mostrar un preview del nuevo Avatar, tu Navegador no lo soporta.<br />Aún así podrá actualizarse sin problemas</span>'
						$('div.preview').html html

		$('#resource_imagen').on 'change', previewAvatar

			



