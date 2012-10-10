$(document).ready () ->
	
	$('#header').addClass('perfil')
	if $('#header #show').is(':visible')
		$('#header #show').hide();
	

	$('#user-tabs a').click (e) ->
		e.preventDefault();
		$(this).tab('show')
		$('.pagination').remove()


	$('input:file').change () ->
		$('#resource_url').attr('disabled','disabled').val('')
		$('#resource_type').val('imagen')

	$('#resource_url').focusout () ->
		if $(this).val()!=''
			$('input:file').attr('disabled','disabled').val('')
			$('#resource_type').val('video')
			

	#Metodos para manejar la subida de imagenes
	$('#new_resource').on 'ajax:beforeSend',(e,x,s) ->
		$('body').toggleClass('wait')
		$('#subir_imagen').attr('disabled','disabled');
		
			
	.on 'ajax:complete',(e,data) ->
		$.get '/metadata/last_resource',(data) ->
			$('#new_resource').reset()
			$('#subir_imagen').removeAttr('disabled')
			$('body').toggleClass('wait')
			$container = $('#subidas #listado_container2')
			data = $(data)
			$container.append(data).masonry('appended',data)
	.on 'ajax:aborted:required', () ->
		$.pnotify
			title: "Error"
			text: "Debes completar todos los campos del formulario"
			opacity:.5
			type:"error"


	loadSeccionData = (url) ->
		$('#perfil-data').fadeOut('fast')
		container = $('#listado_container')
		container.empty()
		imgs = $('div.imagenes')
		vids = $('div.videos')
		if imgs.hasClass('active') && !vids.hasClass('active')
			url = "imagenes_#{url}"
		else if !imgs.hasClass('active') && vids.hasClass('active')
			url = "videos_#{url}"
		if url == 'index'
			url = 'todos_index'
		
		$.get "/#{url}",(data) ->
			$('#page-nav a').attr('href',"#{url}/2")
			data = $(data)
			data.hide()
			container.append(data)
			container.imagesLoaded () ->
				container.fadeIn 'fast',() ->
					container.masonry('reload')
					data.fadeIn()


	location = window.location.href.split('#')[1]
	switch location
		case 'valorados'
			$('#secciones2 #valorados').trigger 'click'
		case 'favoritos'
			$('#secciones2 #favoritos').trigger 'click'

	$('#secciones2 div').click (e) ->
		$(this).siblings().removeClass 'active'
		$(this).addClass('active')
		url = $(this).attr('data-url')
		if url?
			loadSeccionData url
		else
			id = $(this).attr('id')
			switch id 
				when 'perfil'
					$('#listado_container').fadeOut('fast')
					$('#perfil-data').fadeIn('fast')
				when 'logout'
					$('#salir').trigger 'click'

		false
				
			

	$('#a_subidas').on 'ajax:beforeSend',(e,x,s) ->
		e.stopPropagation()
		e.preventDefault()
		$('#votadas #listado_container2').empty()
		

		$.get '/metadata/subidas',(data) ->
			$container = $('#subidas #listado_container2')
			
			data = $(data)
			$container.append(data)
			
			
			$container.imagesLoaded () ->
				$container.masonry
					itemSelector:'.item',
					isAnimated:true,
					gutterWidth:2
				$container.fadeIn()
				$container.masonry('reload')
			
	
	
		

	
	
		
		
			
		
	

			
