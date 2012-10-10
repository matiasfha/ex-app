$(document).ready () ->
	handleIn = (e) ->
		# if !$(this).parent().hasClass 'voted'
		$(this).prevAll().andSelf().addClass('over')
		.nextAll().removeClass('vote')
	handleOut = (e) ->
			# if !$(this).parent().hasClass 'voted'
			$(this).prevAll().andSelf().removeClass 'over'

	$('.rating .star').live 'click', (e) ->
		parent = $(this).parent()
		rating = $(this).siblings().add(this).filter('.over').length
		$(this).siblings().andSelf().filter('.over').addClass 'vote'
		pid = parent.attr('data-id')
		
		$.post "/votos/#{pid}/#{rating}",(data) ->
			if data.result == true
				html = "#{data.promedio}/#{data.total}"
				$("##{pid} .votos_result").html(html)
				text =  "Has votado por este recurso"
				if parent.hasClass('voted')
					text = "Has cambiado tu voto por este recurso"
				$.pnotify
					title: "Exito"
					text: text
					opacity:.8
					type:"success"
		

	$('.rating .star').live
		mouseenter: handleIn,
		mouseleave: handleOut	

	# Maneja el evento hover sobre la imagen para mostrar
	# botones sociales
	$('.item').live 
		mouseenter: (e) ->
			item = $(e.currentTarget) 
			item.find('.overlay').fadeIn() #.slideDown('slow')
			
		,mouseleave:(e) ->
			item = $(e.currentTarget) 
			item.find('.overlay').fadeOut() #.hide('slide',{direction:"down"},600)


	#Al clickear sobre la flecha para desplegar
	#Comentarios y descripcion.
	#Calcula la nueva posicion del elemento que se encuentra
	#bajo la tarjeta elejida
	slideImageExtraInfo = (parent) ->
		siblings = parent.nextAll('.item')
		extra = parent.find('.extra')
		items = []
		flecha = parent.find('.flecha_desplegar')
		items.push s for s in siblings when $(s).css('left')==parent.css('left')

		element = extra.clone()
		element.children().css({display:'block',visibility:'hidden'})
		element.css({display:'block',visibility:'hidden'}).insertAfter(parent.find('.extra'))
		newTop = element.height()
		element.remove()

		#Para cada item posicionarlo en top:newTop
		for item in items 
			top = parseInt($(item).css('top'))
			
			if flecha.hasClass('active')
				 top = $(item).attr('original-top')
			else
				$(item).attr('original-top',top)
				top = top + newTop + 30

			$(item).animate {top:top},300
		if flecha.hasClass('active')
			extra.slideUp 'fast'
		else
			extra.slideDown 'fast'
			
		flecha.toggleClass('active')
		false

	$('.item .flecha_desplegar').live 'click', (e) ->
		parent = $(this).parent()
		slideImageExtraInfo parent
	$('.item .btn-comentar').live 'click', (e) ->
		parent = $(this).parent().parent().parent().parent().parent()
		slideImageExtraInfo parent
		parent.find('input.comentar').focus()			
			
		

	# Maneja la interaccion del boton like
	$('.item .overlay .btn-like').live 'click', (e) ->
		e.preventDefault()
		e.stopPropagation()
		target = $(e.currentTarget)
		resource_id = target.attr('data-id')
		parent =  $("##{resource_id}.item")
		
		if !target.hasClass 'active'
			$.post '/resources/add_like',{id:resource_id},(data) -> 
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
					parent.find('div.botonera span.like-count').html html	
					target.addClass 'active'
		else
			$.post '/resources/remove_like',{id:resource_id},(data) ->
				if data!= -1
					$.pnotify
						title:"Ya NO te gusta esta imagen"
						text:""
						opacity:.8
						type:'success'			
					html = """<i class="heart" ></i>#{data}"""
					parent.find('div.botonera span.like-count').html html	
					target.removeClass 'active'
				
		false


	#Maneja el actuar de los botones de seccio
	$('#botonera div.imagenes,#botonera div.videos').click (e) ->
		if !$('#botonera').hassClass('perfil')
			target = $(e.currentTarget)
			target.toggleClass('active')
			if target.siblings('.active').length == 0
				target.siblings().addClass('active')
			
			url = $('#secciones div.active').attr('data-url')
			loadSeccionData url

	

	#Maneja la seccion a cargar via ajax

	loadSeccionData = (url) ->
		container = $('#listado_container')
		container.empty()
		
		imgs = $('div.imagenes')
		vids = $('div.videos')
		if imgs.hasClass('active') && !vids.hasClass('active')
			url = "/imagenes_#{url}"
		else if !imgs.hasClass('active') && vids.hasClass('active')
			url = "/videos_#{url}"
		if url == 'index'
			url = 'todos_index'
		
		$.get url,(data) ->
			$('#page-nav a').attr('href',"#{url}/2")
			data = $(data)
			data.hide()
			container.append(data)
			container.imagesLoaded () ->
				container.fadeIn 'fast',() ->
					container.masonry('reload')
					data.fadeIn()

	$('#secciones div').click (e) ->
		$(this).siblings().removeClass('active')
		$(this).addClass('active')
		url = $(this).attr('data-url')
		loadSeccionData(url)
		
		false		


	onLoadIndex = () ->
		if $('.item').length == 0
			$('#b_nuevos').trigger 'click'
				
	onLoadIndex()

	# Maneja la creación de comentarios
	$('input.comentar').live 'keydown', (e) ->
		if e.which == 13
			e.preventDefault()
			e.stopPropagation()
			input = $(this)
			input.attr 'disabled','disabled'
			resource_id = input.attr('data-id')
			data = 
				comment:
					resource_id: resource_id
					contenido: input.val()
				
			parent = $("##{resource_id}.item")	

			$.post '/comments',data, (data) ->
				if data!=false
					container = parent.find('.extra .comentarios')
					items = []
					siblings = parent.nextAll('.item')
					items.push s for s in siblings when $(s).css('left')==parent.css('left')

					element = $(data).clone()
					element.css({display:'block',visibility:'hidden'}).insertAfter(container)
					newTop = element.height()
					element.remove()
					container.prepend(data)
					for item in items 
						top = parseInt($(item).css('top')) + newTop 
						$(item).animate {top:top},300

					input.val('')
					total = parent.find('div.botonera span.comment-count span').html()
					total = parseInt(total)+1
					parent.find('div.botonera span.comment-count span').html(total)
				input.removeAttr 'disabled'

	




	