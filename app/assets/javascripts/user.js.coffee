$(document).ready () ->
	

	$('#user-tabs a').click (e) ->
		e.preventDefault();
		$(this).tab('show')
		$('.pagination').remove()

	$('#new_picture').on 'ajax:beforeSend',(e,x,s) ->
		$('#loading').show();
		$('#formulario_picture').fadeOut 'fast'
			
	.on 'ajax:complete',(e,data) ->
		$.get '/metadata/reload_list', (data) ->
			$('#listado_container').fadeOut 'fast',() ->
				$('#listado_container').html data
				$('#new_picture').reset()
				$('#formulario_picture').fadeIn 'fast'
				$('#listado_container').stop().fadeIn().imagesLoaded () ->
					$('#listado_container').masonry({
						itemSelector:'.item',
						isAnimated:true,
						gutterWidth:2
					});
					$('#loading').hide();
							
		

	.on 'ajax:aborted:required', () ->
		$.pnotify
			title: "Error"
			text: "Debes completar todos los campos del formulario"
			opacity:.5
			type:"error"


	$('#a_perfil').on 'click',(e) ->
		$('#votadas #listado_container').empty()
		$('#subidas #listado_container').empty()


	$('#a_votadas').on 'click',(e) ->
		e.stopPropagation()
		e.preventDefault()
		$('#subidas #listado_container').empty()
		$.get '/metadata/mas_votadas',(data) ->
			$container = $('#votadas #listado_container');
			data = $(data)
			$container.append(data)
			
			$container.imagesLoaded () ->
				$container.fadeIn 'fast',() ->
					$container.masonry('reload')
				
			

	$('#a_subidas').on 'ajax:beforeSend',(e,x,s) ->
		e.stopPropagation()
		e.preventDefault()
		$('#votadas #listado_container').empty()
		$.get '/metadata/subidas',(data) ->
			$container = $('#subidas #listado_container')
			data = $(data)
			$container.append(data)
			
			$container.imagesLoaded () ->
				$container.masonry
					itemSelector:'.item',
					isAnimated:true,
					gutterWidth:2
				$container.fadeIn 'fast',() ->
					$container.masonry('reload')
			
			 
			
