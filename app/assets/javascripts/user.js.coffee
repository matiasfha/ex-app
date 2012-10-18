$(document).ready () ->
	window.loading = false; #A falso el loader para el scroll infinito
	$('#header').addClass('perfil')
	if $('#header #show').is(':visible')
		$('#header #show').hide();
	
	$('#nuevo_recurso').live 'click',(e) ->
		$('#modal-form').modal({keyboard:false},'show')
	$('input:file').change () ->
		$('#resource_url').attr('disabled','disabled').val('')
		$('#resource_type').val('imagen')

	$('#resource_url').focusout () ->
		if $(this).val()!=''
			$('input:file').attr('disabled','disabled').val('')
			$('#resource_type').val('video')
			
	
	#Metodos para manejar la subida de imagenes
	$('#new_resource').on 'ajax:beforeSend',(e,x,s) ->

		e.stopPropagation()
		data = $('#new_resource').serializeObject()
		if data.resource.titulo=="" || data.resource.descripcion==""
			e.preventDefault()
			$.pnotify
				title: "Dandoo.tv"
				text: "Debes completar los campos requeridos"
				opacity:.8
				type:"error"
			if data.resource.titulo==""
				$('#resource_titulo').parent().parent().addClass('error')
			if data.resource.descripcion==""
				$('#resource_descripcion').parent().parent().addClass('error')
			false
		$('body').toggleClass('wait')
		$('#subir_recurso').attr('disabled','disabled');
		$('#cancelar').attr('disabled','disabled');
	.on 'ajax:afterSend',(e) ->
		$('#resource_descripcion').attr('disabled','disabled');
		$('#resource_titulo').attr('disabled','disabled');
		$('#resource_url').attr('disabled','disabled');
		$('#resource_imagen').attr('disabled','disabled');	
		
	.on 'ajax:complete',(e,data) ->
		if data.result == true
			$.get '/metadata/last_resource',(data) ->
				$('#new_resource').reset()
				$('#new_resource input').removeAttr('disabled')
				$('#cancelar, #subir_recurso').removeAttr('disabled');
				$('body').toggleClass('wait')
				$('#modal-form').modal('hide')
				$container = $('#listado_subidas')
				data = $(data)
				data.show().css({ opacity: 0 });
				
				$container.prepend(data).imagesLoaded () ->
					data.animate({opacity:1})
					$container.masonry('reload')
		else
			console.log data
	.on 'ajax:aborted:required', () ->
		$.pnotify
			title: "Dandoo.tv"
			text: "Debes completar todos los campos del formulario"
			opacity:.8
			type:"error"


	loadSeccionData = (url) ->
		$('#perfil-data').fadeOut('fast')
		container = $('#listado_container')
		container.empty().removeClass('disabled')
		imgs = $('div.imagenes')
		vids = $('div.videos')
		if imgs.hasClass('active') && !vids.hasClass('active')
			url = "imagenes_#{url}"
		else if !imgs.hasClass('active') && vids.hasClass('active')
			url = "videos_#{url}"
		if url == 'index'
			url = 'todos_index'
		
		$.get "/metadata/#{url}",(data) ->
			$('#page-nav a').attr('href',"/metadata/#{url}/2")
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
		window.loading = false;
		if url?
			$('#upload').hide()
			loadSeccionData url
		else
			id = $(this).attr('id')
			switch id 
				when 'perfil'
					$('#upload').show()
					$('#listado_container').fadeOut('fast').addClass('disabled')
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
			gutterWidth:11


	      	
	
		

	
	
		
		
			
		
	

			
