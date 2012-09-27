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

	$('.rating .star').hover handleIn, handleOut	

	# Maneja el evento hover sobre la imagen para mostrar
	# la descripcion, autor y botones sociales
	$('.imagen').hover (e) ->
		item = $(e.currentTarget) 
		item.find('.overlay.up').fadeIn()
		item.find('.overlay.bottom').show('slide',{direction:"up"},300)
	, (e) ->
		item = $(e.currentTarget) 
		item.find('.overlay.up').fadeOut()
		item.find('.overlay.bottom').hide('slide',{direction:"down"},300)


	# Maneja la interaccion del boton like
	$('.btn_like').click (e) ->
		e.preventDefault()
		e.stopPropagation()
		target = $(e.currentTarget)
		parent = target.parent().parent().parent()
		picture_id = parent.attr('id')
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
				html = """<i class="icon-heart" ></i>#{data}"""
				parent.find('.like-count').html html	
				
		false


	

		




	