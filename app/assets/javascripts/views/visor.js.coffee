define [
	'jquery'
	'backbone'
	'models/resource'
	'hbs!templates/visor'
	'froogaloop2.min'
	'models/comentario'
	'hbs!templates/comentarios/comentario'
],($,Backbone,ResourceModel,VisorTPL,F,MComentario,TComentario) ->
	class VisorView extends Backbone.View
		el:$('#templating')
		events:
			'mouseenter .rating .star':'ratingON'
			'mouseleave .rating .star':'ratingOFF'
			'click .rating .star':'ratingSet'
			'mouseenter .thi':'showOverlay'
			'mouseleave .thi':'hideOverlay'
			'click .more':'showMoreComments'
			'keydown input.text_comentario':'crearComentario'
			'click img.comentar':'crearComentario'
			'click .social .comment':'comentar'
			'click .social .like':'like'

		initialize:(@parent) ->
			@tpl = eval(VisorTPL)
			@tpl_comment = eval(TComentario)
			@id = parent.attr('id')
			@model = new ResourceModel
				id:@id
			@model.fetch()
			@model.on 'change',() =>
				@render()
			
		render: =>
			html = @tpl @model.toJSON()
			$(@el).append(html)
			$('#visor-modal').reveal
				animation:'fadeAndPop'
				opened: () =>
					if @model.get('type')=='video'
						if @model.get('provider')=='youtube'
							@loadYoutubePlayer @model.get('video_id'),'ytplayer'
						else #vimeo
							@loadVimeoPlayer @model.get('url')
				closed: () => 
					@close()

		close: =>
			$(@el).empty()
			$(@el).undelegate()

		crearComentario:(e) =>
			enviar = false
			if e.type == 'keydown'
				if e.which == 13
					enviar = true
					e.preventDefault()
			else
				if e.type == 'click' && $(e.currentTarget).hasClass 'comentar'
					enviar = true
			if enviar
				resource_id = $('#comment_resource_id').val()
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

						item = $("##{resource_id}.item")
						count = $('#visor-modal .comment_count')
						total = parseInt(count.html())+1
						count.html(total)
						item.find('.comment_count').html(total)
						$('#visor-modal .append_comments').append html
						item.find('.nuevos_comentarios').append html
		like: (e) ->
			target = $(e.currentTarget)
			id = target.attr('data-id')
			if target.hasClass 'active'
				action = 'remove'
			else
				action = 'add'
			$.post "/resources/like/#{id}/#{action}",(d) ->
				$('#visor-modal .like_count').text(d)
				$("##{id}.item").find('.like_count').text(d)
				target.toggleClass 'active'
				$("##{id}.item").find('.like').toggleClass 'active'

		comentar:(e) =>
			$('#visor-modal').find('.text_comentario').focus()
			false

		showMoreComments:(e) ->
			target = $(e.currentTarget)
			if target.hasClass 'active'
				$('.nuevos_comentarios').fadeIn()
				$('.more_comentarios').slideUp()
			else
				$('.nuevos_comentarios').fadeOut()
				$('.more_comentarios').slideDown()
			$(e.currentTarget).toggleClass 'active'
		showOverlay:(e) =>
			$(e.currentTarget).find('.overlay').show()

		hideOverlay:(e) =>
			$(e.currentTarget).find('.overlay').hide()	


		ratingON:(e) ->
			$(e.currentTarget).prevAll().andSelf().addClass('on')
			$(e.currentTarget).nextAll().removeClass('on')

		ratingOFF:(e) ->
			$(e.currentTarget).prevAll().andSelf().removeClass('on')

		ratingSet:(e) =>
			$(e.currentTarget).siblings('.voted').andSelf().removeClass 'voted'
			elems = $(e.currentTarget).siblings('.on').andSelf()
			elems.addClass 'voted'
			count = elems.length
			
			$.post "/votos/#{@id}/#{count}",(data) =>
				if data.result == true
					html = "#{data.promedio}/#{data.total}"
					$('#visor-modal').find('.votos_count').html html
					$("##{@id}").find('.votos_count').html html
					html = ''
					for i in [1..data.promedio]
						html+='<img src="/assets/STAR_ON.gif"/>'
					for i in [data.promedio...5]
						html+='<img src="/assets/STAR_OFF.gif"/>'	
					$('#visor-modal').find('.estrellas').html html
					$("##{@id}").find('.estrellas').html html



		loadVimeoPlayer:(video_url) ->
			player = $f($('#vmplayer')[0]);
			done = false
			player.addEvent 'ready', (player_id) ->
				$('.start').live 'click',(e) ->
					player.api 'play'
					$('.start').addClass('active')
					$('.pausa').removeClass('active')


				$('.pausa').live 'click',(e) ->
					player.api 'pause'
					$('.start').removeClass('active')
					$('.pausa').addClass('active')

				player.addEvent 'playProgress',(data,id) ->
					current = data.seconds
					percent = data.percent*100
					$('.video_controls .time').html String(current).toHHMMSS()
					$('.video_controls .bar').css('width',percent+'%')

		loadYoutubePlayer: (video_id, player_id) ->
			player = null
			done = false
			onYoutubeIframeAPIReady = (video_id, player_id) ->
				options = 
					width: '754'
					height: '492'
					videoId: video_id
					playerVars: 
						autoplay: 0
						controls: 0
						enablejsapi: 1
						showinfo: 0
						iv_load_policy: 3
						color: 'white'
						theme: 'light'
						origin: 'http://dandoodev.herokuapp.com'
						autohide: 1
						disablekb: 1
						modestbranding: 1
						playerpiid: player_id
						rel: 0
					events: 
						'onReady': (event) ->
							# event.target.playVideo()
							done = false
						'onStateChange': (event) ->
							switch event.data
								when -1 #unstarted
									return
								when 0 #ended
									clearInterval(0)
									$('.pausa').addClass('active')
								when 1 #playing
									$('.start').addClass('active')
									$('.pausa').removeClass('active')
									setInterval () ->
										current = player.getCurrentTime()
										$('.video_controls .time').html String(current).toHHMMSS()
										percentage = (current / player.getDuration())*100
										$('.video_controls .bar').css('width',percentage+'%')
									,500
								when 2 #paused
									$('.start').removeClass('active')
									$('.pausa').addClass('active')
									clearInterval(0)
								when 3 #buffering
									$('.start').removeClass('active')
									$('.pausa').addClass('active')
									clearInterval(0)
									return
								when 5
									$('.start').removeClass('active')
									$('.pausa').addClass('active')
									clearInterval(0)
									done = false	

				player = new YT.Player player_id, options

				$('.start').live 'click', (e) ->
					switch player.getPlayerState()
						when -1,0,2,5
							player.playVideo()
						else 
							return
						
				$('.pausa').live 'click',(e) ->
					if player.getPlayerState()==1
						player.pauseVideo()

			onYoutubeIframeAPIReady(video_id, player_id)	

		