$(document).ready () ->
	

	$('#user-tabs a').click (e) ->
		e.preventDefault();
		$(this).tab('show')
		$('.pagination').remove()

	$('#new_picture').on 'ajax:beforeSend',(e,x,s) ->
		$('#formulario_picture').fadeOut 'fast',() ->
			$('#mensaje_carga').fadeIn()
	.on 'ajax:complete',(e,data) ->
		$('#mensaje_carga').fadeOut()	
		$.get '/metadata/reload_list', (data) ->
			$('#listado_imagenes').fadeOut 'fast',() ->
				$('#listado_imagenes').html data
				$('#new_picture').reset()
				$('#formulario_picture').fadeIn 'fast'
				$('#listado_imagenes').stop().fadeIn()
							
		

	.on 'ajax:aborted:required', () ->
		$.pnotify
			title: "Error"
			text: "Debes completar todos los campos del formulario"
			opacity:.5
			type:"error"