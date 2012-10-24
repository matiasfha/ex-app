define [
	'jquery'
	'backbone'
	'collections/resources'
	'text!templates/resources/listado_resources.hbs'
	'twitter/bootstrap'
	'text!templates/comentarios/_comentarios.hbs'
	'text!templates/resources/_botonera.hbs'
	'text!templates/resources/_overlay.hbs'
	'text!templates/resources/_descripcion.hbs'
	'text!templates/comentarios/comentario.hbs'
	'models/comentario'
	'views/visor'
],($,Backbone,ResourcesCollection,Template,Bootstrap,PComentarios,PBotonera,POverlay,PDescripcion,TComentario,ComentarioModel,VisorView) ->
	class ImagenesView extends Backbone.View
		el:$('#listado_container')
		events:
			'click .item .flecha_desplegar':'desplegar'
			'click .rating .star'		:'votar'
			'mouseenter .rating .star'	:'hoverStar'
			'mouseleave .rating .star'	:'leaveStar'
			'mouseenter .item'			:'showOverlay'
			'mouseleave .item'			:'hideOverlay'
			'click .item .overlay .btn-like':'like'
			'click .item .btn-comentar'	:'showComment'
			'click .item .btn-twitter, .item .btn-facebook':'share'
			'keydown input.comentar'	:'crearComentario'
			'click i.delete_comment'	:'borrarComentario'
			'click .item .image_holder .overlay':'showVisor'
		initialize: (@collection_url) ->
			@tpl = eval(Template)
			#Get Partials
			eval(PComentarios)
			eval(PBotonera)
			eval(POverlay)
			eval(PDescripcion)
			@tpl_comentario = eval(TComentario)
			@resources = new ResourcesCollection()
			@resources.on 'reset', () =>
				@load()
			@render()


		render: =>
			imgs = $('a.imagenes')
			vids = $('a.videos')
			if imgs.hasClass('active') && !vids.hasClass('active')
				@collection_url = "imagenes_#{@collection_url}"
			else if !imgs.hasClass('active') && vids.hasClass('active')
				@collection_url = "videos_#{@collection_url}"
			if @collection_url == 'index'
				@collection_url = 'todos_index'
			@resources.url = @collection_url
			@resources.fetch()

		close: =>
			$(@el).empty().undelegate()

		#Acciones para el overlay de la imagen
		showOverlay: (e) ->
			$(e.currentTarget).find('.overlay').fadeIn()

		hideOverlay: (e) ->
			$(e.currentTarget).find('.overlay').fadeOut()

		share: (e) ->
			window.open $(e.currentTarget).parent().attr('href')
			false

		showComment:(e) =>
			parent = $(e.currentTarget).parent().parent().parent().parent().parent()
			@slideImageExtraInfo parent
			parent.find('input.comentar').focus()	
			false	

		like:(e) ->
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

		#Acciones para la estrellas del rating
		hoverStar: (e) ->
			$(e.currentTarget).prevAll().andSelf().addClass('over')
			
		leaveStar: (e) ->	
			$(e.currentTarget).prevAll().andSelf().removeClass('over')
		

		votar: (e) ->
			target = $(e.currentTarget)
			parent = target.parent()
			target.siblings().andSelf().removeClass 'vote'
			rating = target.siblings().add(this).filter('.over').length + 1
			target.siblings().andSelf().filter('.over').addClass 'vote'
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
			false

		#Carga el template correspondiente a la seccion
		load: =>
			$(@el).children().remove() #.empty()
			window.loading = false
			$('#page-nav a').attr('href',"/#{@collection_url}/2")
			data = $(@tpl(@resources.toJSON()[0]))
			data.hide()
			$(@el).append(data)
			$(@el).imagesLoaded () =>
				$(@el).fadeIn 'fast',() =>
					$(@el).masonry('reload')
					data.fadeIn()

		desplegar: (e) =>
			parent = $(e.currentTarget).parent()
			@slideImageExtraInfo parent
			false

		slideImageExtraInfo: (parent) =>
			flecha = parent.find('.flecha_desplegar')
			extra = parent.find('.extra')
			if !flecha.hasClass 'active'
				siblings = parent.nextAll('.item')
				items = []
				
				items.push s for s in siblings when $(s).css('left')==parent.css('left')

				element = extra.clone()
				element.children().css({display:'block',visibility:'hidden'})
				element.css({display:'block',visibility:'hidden'}).insertAfter(parent.find('.extra'))
				newTop = element.height()
				element.remove()

				#Aumentar el tamaño del contenedor si es necesario
				altura = parent.height()+newTop

				for item in items
					altura = altura + $(item).height()
				
				if $('#listado_container').height() < altura
					nueva = $('#listado_container').height() + (altura - $('#listado_container').height()) + 60
					$('#listado_container').animate {height:nueva},10
					
				

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
				flecha.removeClass 'active'
			else
				extra.slideDown 'fast'
				flecha.addClass('active')
			false

		#Maneja la creacion y eliminacion de comentarios
		crearComentario: (e) =>
			if e.which == 13
				input = $(e.currentTarget)
				input.attr 'disabled','disabled'
				resource_id = input.attr('data-id')
				data = 
					comment:
						resource_id: resource_id
						contenido: input.val()
				parent = $("##{resource_id}.item")	
				comentario = new ComentarioModel data
				comentario.save()
				comentario.on 'sync', (data) =>
					if data!=false
						container = parent.find('.extra .comentarios')
						items = []
						siblings = parent.nextAll('.item')
						items.push s for s in siblings when $(s).css('left')==parent.css('left')
						data = @tpl_comentario(comentario.toJSON())
						element = $(data).clone()
						element.css({display:'block',visibility:'hidden'}).insertAfter(container)
						newTop = element.height()
						element.remove()
						parent.find('.extra .comentarios .comentarios_nuevos').append(data)
						for item in items 
							top = parseInt($(item).css('top')) + newTop 
							$(item).animate {top:top},300

						input.val('')
						total = parent.find('div.botonera span.comment-count span').html()
						total = parseInt(total)+1
						parent.find('div.botonera span.comment-count span').html(total)
					input.removeAttr 'disabled'
				false

		borrarComentario: (e) ->
			target = $(e.currentTarget)
			parent = target.closest('.item')
			$('#confirmModal #mensaje').text('Esto eliminará completamente el comentario')
			$('#confirmModal button.btn-danger').attr 'data-href', $(e.currentTarget).attr('data-href')
			$('#confirmModal button.btn-danger').on 'click',(e) ->
				$.ajax
					url: $(e.currentTarget).attr('data-href')
					type:'DELETE'
					success:(data) ->
						if data!=false
							parent.find("#comentario-#{data.cid}").fadeOut 'slow',() ->
								parent.find("#comentario-#{data.cid}").remove()
								actual = parent.find('div.botonera span.comment-count span').text()
								parent.find('div.botonera span.comment-count span').html(parseInt(actual) - 1)
								$('#confirmModal').modal 'hide'
								false		
			$('#confirmModal').modal 'show',{keyboard:false}
			false
		
		showVisor:(e) ->
			id = $(e.currentTarget).closest('.item').attr('id')
			new VisorView id
