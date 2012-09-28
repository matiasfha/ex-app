$(document).ready () ->
	handleIn = (e) ->
		if !$(this).parent().hasClass 'voted'
			$(this).prevAll().andSelf().addClass('over')
			.nextAll().removeClass('vote')
	handleOut = (e) ->
			if !$(this).parent().hasClass 'voted'
				$(this).prevAll().andSelf().removeClass 'over'

	$('.rating .star').click (e) ->
		if !$(e.currentTarget).parent().hasClass 'voted'
			$(this).parent().addClass 'voted'
			rating = $(this).siblings().add(this).filter('.over').length
			pid = $(this).parent().attr('data-id')
			$.post "/votos/#{pid}/#{rating}",(data) ->
				if data.result == true
					html = "#{data.promedio}/#{data.total}"
					$("##{pid} .votos_result").html(html)
				else
					$.pnotify
						title: "Error"
						text: "Ya habías votado en esta imagen"
						opacity:.5
						type:"error"

	$('.rating .star').live
		mouseenter: handleIn,
		mouseleave: handleOut	

	# Maneja el evento hover sobre la imagen para mostrar
	# la descripcion, autor y botones sociales
	$('.item').hover (e) ->
		item = $(e.currentTarget) 
		item.find('.overlay').slideDown('slow') #fadeIn()
		
	, (e) ->
		item = $(e.currentTarget) 
		# item.find('.overlay').slideUp() #fadeOut()
		item.find('.overlay').hide('slide',{direction:"down"},600)

	$('.item .overlay').click (e) ->
		item = $(e.currentTarget)
		href = item.parent().find('img.picture').parent().attr('href')
		window.location.href = href

	# Maneja la interaccion del boton like
	$('.btn_like').click (e) ->
		e.preventDefault()
		e.stopPropagation()
		target = $(e.currentTarget)
		picture_id = target.attr('data_id')
		parent =  target.parent().parent().parent().parent()
		
		$.post '/pictures/add_like',{id:picture_id},(data) -> 
			if data == -1
				$.pnotify
					title: "Error"
					text: "Ya habías marcado que te gusta esta imagen"
					opacity:.8
					type:"error"
			else
				$.pnotify
					title:"Te gusta esta imagen"
					text:""
					opacity:.8
					type:'success'
				html = """<i class="heart" ></i>#{data}"""
				parent.find('div.caption span.like-count').html html	
				
		false


	

		




	