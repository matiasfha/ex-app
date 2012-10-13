$(document).ready () ->

	$('.item .image_holder .overlay').live 'click', (e) ->
		e.stopPropagation()
		e.preventDefault()
		href = $(this).siblings('a').attr('href')
		$.get href, (data) ->
			if data!=false
				$('body').css({'overflow-y':'hidden'})
				$('body').append $(data)
				maskHeight = $(document).height()
				maskWidth = $(document).width()
				mask = $('#mask')
				mask.css 
					width:maskWidth
					height:maskHeight

				winH = $(window).height()
				winW = $(window).width()

				elem = $(data).clone()

				elem.css({display:'block',visibility:'hidden'}).insertAfter(parent.find('body'))
				w = elem.width()
				h = elem.height()
				elem.remove()
				mask.show 'fast',() ->
					mask.fadeTo 'slow',0.6, () ->
						$('.visor-modal').slideDown()

	$('body').keydown (e) ->

		if e.which==27 && $('.visor').length > 0
			$('#mask').click()

	$('#mask').click (e) ->
		e.stopPropagation()
		$('.visor-modal').slideUp 'fast', ()  ->
			$('#mask').fadeTo 'slow',0, () ->
				$('#mask').hide()
				$('.visor-modal').remove()
				$('body').css({'overflow-y':'auto'})

	# Maneja la interaccion del boton like
	$('.visor-modal .buttons .btn-like').live 'click', (e) ->
		e.preventDefault()
		e.stopPropagation()
		target = $(e.currentTarget)
		resource_id = target.attr('data-id')
		parent =  $(".visor-modal")
		if !target.hasClass 'active'
			$.post '/resources/add_like',{id:resource_id},(data) -> 
				if data == -1
					$.pnotify
						title: "Error"
						text: "Ya habías marcado que te gusta esta imagen"
						opacity:.8
						type:"error"
				else
					html = """<i class="heart" ></i>#{data}"""
					parent.find('div.botonera span.like-count').html html	
					$("##{resource_id}.item div.botonera span.like-count").html html
					target.addClass 'active'
					# $.pnotify
					# 	title:"Te gusta esta imagen"
					# 	text:""
					# 	opacity:.8
					# 	type:'success'
		else
			$.post '/resources/remove_like',{id:resource_id},(data) ->
				if data!= -1
					html = """<i class="heart" ></i>#{data}"""
					parent.find('div.botonera span.like-count').html html	
					$("##{resource_id}.item div.botonera span.like-count").html html
					target.removeClass 'active'

		false

	$('.visor-modal .buttons .btn-comentar').live 'click', (e) ->
		$('input.comentar_modal').focus()
		false
	# Maneja la creación de comentarios

	$('input.comentar_modal').live 'keydown', (e) ->
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
				
			parent = $(".visor-modal")	

			$.post '/comments',data, (data) ->
				if data!=false
					container = parent.find('.comentarios .listado')
					container.append(data)
					container2 = $("##{resource_id}.item .extra .comentarios")
					container2.prepend(data)
					input.val('')
					total = $("##{resource_id}.item div.botonera span.comment-count span").html()
					total = parseInt(total) + 1
					$("##{resource_id}.item div.botonera span.comment-count span").html(total)
					$(".visor-modal div.botonera span.comment-count span").html(total)
				input.removeAttr 'disabled'

	
	