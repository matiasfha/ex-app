# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
	
$(document).ready () ->
	

	$('form[data-remote]#new_comment').live 'ajax:success', (e,data) ->
		if data!=false
			html = $(data)
			$('.list').append(html)
			$('.list .new').show('highlight',{backgroundColor:"#C8FB5E"},'slow',()->$('.list .new').removeClass('new'))
			$('form#new_comment textarea').val('')

	$('form#new_comment textarea').keydown (e) ->
		if e.which == 13
			e.preventDefault()
			e.stopPropagation()
			$('form#new_comment').submit()	

	# Maneja la interaccion del boton like
	$('.btn_like').click (e) ->
		e.preventDefault()
		e.stopPropagation()
		target = $(e.currentTarget)
		parent = target.parent()
		resource_id = parent.attr('data-id')
		$.post '/resource/add_like',{id:resource_id},(data) -> 
			if data == -1
				$.pnotify
					title: "Error"
					text: "Ya habías marcado que te gusta esta imagen"
					opacity:.5
					type:"error"
			else
				$.pnotify
					title:"Te gusta esta imagen"
					text:""
					opacity:.5
					type:'success'
				parent.prepend data
		false

	$('.comentario .close').live 'ajax:success',(e,data) ->
		if data.result==true
			$("##{data.cid}.comentario").fadeOut()
		

	#Handler para el rating
	handleIn = (e) ->
		if !$(this).parent().hasClass 'voted'
			$(this).prevAll().andSelf().addClass('over')
			.nextAll().removeClass('vote')
	handleOut = (e) ->
			if !$(this).parent().hasClass 'voted'
				$(this).prevAll().andSelf().removeClass 'over'

	$('.star').click (e) ->
		if !$(e.currentTarget).parent().hasClass 'voted'
			$(this).parent().addClass 'voted'
			rating = $(this).siblings().add(this).filter('.over').length
			pid = $(this).parent().attr('data-id')
			$.post "/votos/#{pid}/#{rating}",(data) ->
				if data.result == true
					html = "#{data.promedio}/#{data.total}"
					$('#votos_result').html(html)
				else
					$.pnotify
						title: "Error"
						text: "Ya habías votado en esta imagen"
						opacity:.5
						type:"error"

	$('.star').hover handleIn, handleOut	