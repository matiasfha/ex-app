$(document).ready () ->
	

	$('#user-tabs a').click (e) ->
		e.preventDefault();
		$(this).tab('show')
		$('.pagination').remove()


	#Metodos para manejar la subida de imagenes
	$('#new_picture').on 'ajax:beforeSend',(e,x,s) ->
		$('body').toggleClass('wait')
		$('#subir_imagen').attr('disabled','disabled');
			
	.on 'ajax:complete',(e,data) ->
		$.get '/metadata/last_picture',(data) ->
			$('#new_picture').reset()
			$('#subir_imagen').removeAttr('disabled')
			$('body').toggleClass('wait')
			$container = $('#subidas #listado_container')
			data = $(data)
			$container.append(data).masonry('appended',data)
	.on 'ajax:aborted:required', () ->
		$.pnotify
			title: "Error"
			text: "Debes completar todos los campos del formulario"
			opacity:.5
			type:"error"


	#Metodos para manejar los tabs
	$('#a_perfil').on 'click',(e) ->
		$('#votadas #listado_container').empty()
		$('#subidas #listado_container').empty()


	$('#a_votadas').on 'click',(e) ->
		e.stopPropagation()
		e.preventDefault()
		$('#subidas #listado_container1').empty()
		
		
		$.get '/metadata/mas_votadas',(data) ->
			$container = $('#votadas #listado_container1');
			data = $(data)
			$container.append(data)
			
			$container.imagesLoaded () ->
				$container.fadeIn 'fast',() ->
					$container.masonry('reload')
				
			

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
				$container.fadeIn 'fast',() ->
					$container.masonry('reload')
			
	
	#Infinite scrolling mas_votadas
	image_container = $('#listado_container1')
	image_container.masonry
		itemSelector:'.item'
		isAnimated:true
		gutterWidth:2
	
	image_container.imagesLoaded () ->
		image_container.fadeIn()
		image_container.masonry('reload')
		

	image_container.infinitescroll
		navSelector:'#page-nav1'
		nextSelector:'#page-nav1 a'
		itemSelector:'.item'
		debug:false
		loadingText:'Cargando nuevos items'
		animate:true
		loadingImg:'http://i.imgur.com/6RMhx.gif'
		doneText:'No hay mas contenido para cargar.'
	,(data) ->
		elems = $(data).css {opacity:0} 
		elems.imagesLoaded () ->
			elems.animate {opacity:1}
			image_container.masonry 'appended',elems,true

	#Infinite scrolling mas_subidas		
	image_container = $('#listado_container2')
	image_container.masonry
		itemSelector:'.item'
		isAnimated:true
		gutterWidth:2
	
	image_container.imagesLoaded () ->
		image_container.fadeIn()
		image_container.masonry('reload')
		

	image_container.infinitescroll
		navSelector:'#page-nav2'
		nextSelector:'#page-nav2 a'
		itemSelector:'.item'
		debug:false
		loadingText:'Cargando nuevos items'
		animate:true
		loadingImg:'http://i.imgur.com/6RMhx.gif'
		doneText:'No hay mas contenido para cargar.'
	,(data) ->
		elems = $(data).css {opacity:0} 
		elems.imagesLoaded () ->
			elems.animate {opacity:1}
			image_container.masonry 'appended',elems,true
	
		
		
			
		
	

			
