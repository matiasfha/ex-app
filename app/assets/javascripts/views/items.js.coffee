define [
	'jquery'
	'backbone'
	'collections/resources'
	'text!templates/resources/listado_items.hbs'
	'models/comentario'
	'text!templates/comentarios/comentario.hbs'
	'views/visor'
	'jquery.imagesloaded.min'
],($,Backbone,Resources,TListado,MComentario,TComentario,VisorView,I) ->
	class ItemView extends Backbone.View 
		el:$('#listado_container')
		events:
			'mouseenter .item':'showOverlay'
			'mouseleave .item':'hideOverlay'
			'click span.more' :'showMore'
			'click .social .comment':'comentar'
			'click .social .like':'like'
			'click img.comentar':'crearComentario'
			'keydown input.text_comentario':'crearComentario'
			'click .item .overlay:not(.social)':'showVisor'


		initialize:(@clasificacion=false,@user_id=null) ->
			
			@tpl = eval(TListado)
			
			@tpl_comment = eval(TComentario)
			
			@resources = new Resources()		
			if @clasificacion!= false
				@getSeccion()
				@resources.url = "#{@resources.url}/#{@clasificacion}/#{@type}/1"
				if @user_id?
					@resources.url = "#{@resources.url}/#{@user_id}"

				@resources.fetch()
				@resources.on 'reset', () =>
					@render()
			else
				@render()
		
		getSeccion: =>
			imgs = $('.section.imagenes')
			vids = $('.section.videos')
			@type = 'todos'
			if imgs.hasClass('active') && !vids.hasClass('active')
				@type = 'imagen'
			else
				if !imgs.hasClass('active') && vids.hasClass('active')
					@type = 'videos'

		render: =>
			if @clasificacion!= false
				items = $('.item')
				$(@el).masonry('remove',items).masonry()
				data = $(@tpl(@resources.toJSON()[0]))
				data.imagesLoaded () =>
					$(@el).empty()
					.html(data).masonry('reload')
					

		close: =>
			$(@el).undelegate()

		showVisor: (e) =>
			target = $(e.currentTarget)
			new VisorView target.closest('.item')

		showOverlay: (e) ->
			$(e.currentTarget).find('.overlay').show()
			false
		hideOverlay: (e) ->
			$(e.currentTarget).find('.overlay').hide()

		like: (e) ->
			target = $(e.currentTarget)
			parent = target.closest('.item')
			id = parent.attr('id')
			if target.hasClass 'active'
				action = 'remove'
			else
				action = 'add'
			$.post "/resources/like/#{id}/#{action}",(d) ->
				target.closest('.item').find('.like_count').text(d)
				target.toggleClass 'active'

		#Al clickear sobre la flecha para desplegar
		#Comentarios y descripcion.
		#Calcula la nueva posicion del elemento que se encuentra
		#bajo la tarjeta elejida
		slideImageExtraInfo: (parent) ->
			siblings = parent.nextAll('.item')
			extra = parent.find('.comentarios')
			items = []
			flecha = parent.find('.more')
			items.push s for s in siblings when $(s).css('left')==parent.css('left')

			element = extra.clone()
			element.children().css({display:'block',visibility:'hidden'})
			element.css({display:'block',visibility:'hidden'}).insertAfter(parent.find('.comentarios'))
			newTop = element.height()
			element.remove()
			
			#Para cada item posicionarlo en top:newTop
			for item in items 
				top = parseInt($(item).css('top'))

				if !flecha.hasClass('active')
					 top = $(item).attr('original-top')
				else
					$(item).attr('original-top',top)
					top = top + newTop + 30
				$(item).animate {top:top},300
			
			if flecha.hasClass('active')
				extra.slideDown 'fast'
			else
				extra.slideUp 'fast'

			false

		showMore: (e) =>
			target = $(e.currentTarget)
			target.toggleClass 'active'
			parent = target.closest('.item')
			if target.hasClass 'active'
				html = """<img src="/assets/ver-.gif" />"""
			else
				html = """<img src="/assets/ver+.gif" />"""
			@slideImageExtraInfo parent
			$(e.currentTarget).html(html)
			false

		comentar:(e) =>
			parent = $(e.currentTarget).closest('.item')
			more = parent.find '.more'
			more.toggleClass 'active'
			if more.hasClass 'active'
				html = """<img src="/assets/ver-.gif" />"""
			else
				html = """<img src="/assets/ver+.gif" />"""
			@slideImageExtraInfo parent
			more.html(html)
			parent.find('.text_comentario').focus()
			false

		crearComentario:(e) =>
			enviar = false
			if e.type == 'keydown'
				if e.which==13
					enviar = true
					e.preventDefault()
			else 
				if e.type =='click' && $(e.currentTarget).hasClass 'comentar'
					enviar = true

			if enviar
				item = $(e.currentTarget).closest('.item')
				resource_id = item.attr('id')
				form = $(e.currentTarget).closest('.new_comment')
				contenido = form.find('.text_comentario').val()
				if contenido!=''
					comment = new MComentario
						'contenido':contenido
						'resource_id':resource_id
					comment.save()
					comment.on 'change',(d) =>
						html = @tpl_comment(d.toJSON())
						
						form.find('.text_comentario').val('')
						count = item.find('.comment_count')
						total = parseInt(count.html())+1
						count.html(total)

						element = html.clone()
						element.children().css({display:'block',visibility:'hidden'})
						element.css({display:'block',visibility:'hidden'}).insertAfter(form)
						height = element.height()
						element.remove()
						$(@el).height ($(@el).height()+height)

						# Reposicionar los elementos inferiores
						siblings = parent.nextAll('.item')
						items = []
						items.push s for s in siblings when $(s).css('left')==item.css('left')
						#Para cada item posicionarlo en top:newTop
						for e in items 
							top = parseInt($(e).css('top'))

							if flecha.hasClass('active')
								 top = $(e).attr('original-top')
							else
								$(e).attr('original-top',top)
								top = top + height + 30
							$(e).animate {top:top},300

						item.find('.nuevos_comentarios').append html
						
			
