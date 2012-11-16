define [
	'jquery'
	'backbone'
	'jquery.masonry.min'
	'jquery.imagesloaded.min'
	'views/items'
	'foundation/jquery.foundation.reveal'
	'File/FileAPI.min'
	'jquery.serializeObject'
],($,Backbone,M,I,ItemsView,R,F,S) ->
	class AppRouter extends Backbone.Router 
		
		routes:
			'ranks':'showRanks'
			'favs':'showFavs'
			'tema':'showTema'

		initialize: ->
			if @itemsView?
				@itemsView.close()
			@itemsView = new ItemsView()
			@masonryLayout()
			$('.tuerca1,.tuerca2').on 'click',@clickTuercas
			$('.guardar').on 'click',@updateUser
			$('#file').on 'change',() ->
				$('#user_avatar').val $('#file').val()
			$('.adjuntar').on 'click',@updateAvatar
			$('.error').live 'focus', (e) ->
				$(e.currentTarget).removeClass 'error'

			$('#resource_imagen').on 'change',@previewResource
			$('#close').on 'click', (e) ->
				e.preventDefault()
				e.stopPropagation()
				$('#subir_modal form').reset()
				$('#subir_modal .preview').empty()
				$('#subir_modal').trigger('reveal:close')
			$('#agregar_resource').on 'submit',@beforeSend
			
		clickTuercas:(e) ->
			if !$('.tuerca1').hasClass 'active'
				$('.menu').show()
			else
				$('.menu').hide()
			$('.tuerca1').toggleClass 'active'
			$('.tuerca2').toggleClass 'active'

		masonryLayout: ->
			container = $('#listado_container')
			gutter = 17
			if $(window).width() <= 1024
				gutter =11
			if $(window).width() <= 800
					gutter = 0;

			container.imagesLoaded () ->
				container.masonry
					itemSelector:'.item'
					isAnimated:!Modernizr.csstransitions
					gutterWidth:gutter
				container.fadeIn()	
				container.masonry('reload')

			$(window).resize (e) ->
				container.fadeOut().stop()
				gutter = 25
				if $(window).width() <= 1024
					gutter = 11
				if $(window).width() <= 800
					gutter = 0;
				container.masonry 'option',{gutterWidth:gutter}	
				container.masonry 'reload'
				container.fadeIn().stop()

		showRanks: =>
			if @itemsView?
				@itemsView.close()
			$('#perfil').fadeOut()
			$('.perfil,.favs,.salir,.tema').removeClass 'active'
			$('.ranks').addClass 'active'
			@itemsView = new ItemsView 'ranks',$('#user_id').val()
			
		showFavs:  =>
			if @itemsView?
				@itemsView.close()
			$('#perfil').fadeOut()
			$('.perfil,.ranks,.salir,.tema').removeClass 'active'
			$('.favs').addClass 'active'
			@itemsView = new ItemsView 'favs',$('#user_id').val()
		
		updateAvatar:(e) ->
			e.preventDefault()
			e.stopPropagation()
			
			file = FileAPI.getFiles $('#file')
			FileAPI.readAsDataURL file[0],(evt) ->
				switch evt.type
					when 'load'
						image = $('<img>')
						image.attr('src',evt.result)
						image.attr('width','150')
						image.attr('heigth',150)
						$('#perfil .avatar').html image 
					when 'progress'
						$('#avatar_prev').animate {opacity: evt.loaded/evt.total * 100}
					else
						html = '<span>No se puede mostrar un preview del nuevo Avatar, tu Navegador no lo soporta.<br />Aún así podrá actualizarse sin problemas</span>'
						$('#perfil .avatar').html html

		previewResource:(e) ->
			e.stopPropagation()
			file = FileAPI.getFiles $('#resource_imagen')
			FileAPI.readAsDataURL file[0],(evt) ->
				switch evt.type
					when 'load'
						image = $('<img>')
						image.attr('src',evt.result)
						image.attr('width','200')
						$('#subir_modal .preview').html image
					when 'progress'
						$('#subir_modal .preview').text 'Cargando..'		
					else
						html = '<span>No se puede mostrar un preview de la nueva Imagen, tu Navegador no lo soporta.<br />Aún así podrá actualizarse sin problemas</span>'
						$('#subir_modal .preview').html html
							
			



		updateUser: (e) ->
			e.preventDefault()
			e.stopPropagation()
			
			# Para cuando se implmente lo del password
			# if $('#user_password').val().length > 0
			# 	#Probar que ambas contraseñas sean iguales
			# 	if $('#user_password').val() != $('#user_password_confirmation').val()
			# 		$('#user_password').addClass 'error'
			# 		$('#user_password_confirmation').addClass 'error'
			# 		continuar = false
			# 	else
			# 		if $('#user_password').val().length < 6
			# 			$('#user_password').addClass 'error'
			# 			$('#user_password_confirmation').addClass 'error'
			# 			continuar = false
			avatar = $('#user_avatar')
			file   = $('#file')
			if avatar.val()!=file.val()
				avatar.remove()
			data = $('form :input[value!=""]').serializeObject()
			
			$.ajax 
				type:'PUT'
				data:data
				url:$('form').attr('action')
				success:(data) ->
					if data.success = true
						window.location.reload()
					else
						alert('Ocurrio un error, intente nuevamente más tarde')
			false
				


		showTema: ->


		beforeSend: (e) ->
			e.preventDefault()
			e.stopPropagation()
			
			if $('#resource_titulo').val()=="" || $('#resource_descripcion').val()==""
				$('#resource_titulo').addClass 'error'
				$('#resource_descripcion').addClass 'error'					
				false
			else
				#Check si hay imagen o video (no ambas ni ninguna)
				
				if $('#resource_imagen').val().length > 0 && $('#resource_url').val().length > 0
					$('#resource_imagen').addClass 'error'
					$('#resource_url').addClass 'error'
					alert('Solo puedes subir una Imagen o Video, no ambas ')
				else
					if $('#resource_imagen').val().length == 0 && $('#resource_url').val().length == 0
						$('#resource_imagen').addClass 'error'
						$('#resource_url').addClass 'error'
						alert('Debes completar o la URL de un Video o seleccionar una Imagen');
					else
						$('#new_resource').submit()
		