$(document).ready () ->
	
	$('#header').addClass('perfil')
	if $('#header #show').is(':visible')
		$('#header #show').hide();
	

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
			$container = $('#listado_subidas')
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
		
		$.get "/metadata/#{url}",(data) ->
			$('#page-nav a').attr('href',"#{url}/2")
			data = $(data)
			data.hide()
			container.append(data)
			container.imagesLoaded () ->
				container.fadeIn 'fast',() ->
					container.masonry('reload')
					data.fadeIn()

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
					location = window.location.href.split('#')
					if location.length > 1
						window.location.href = location[0]
				when 'logout'
					$('#salir').trigger 'click'

		false
				
	location = window.location.href.split('#')[1]
	switch location
		when 'valorados'
			$('#secciones2 div#valorados').trigger('click')
		when 'favoritos'
			$('#secciones2 #favoritos').trigger('click')


	
	$container = $('#listado_subidas')
	$container.imagesLoaded () ->
		$container.masonry
			itemSelector:'.item',
			isAnimated:true,
			gutterWidth:2
		
			
	
	
		

	
	
		
		
			
		
	

			
