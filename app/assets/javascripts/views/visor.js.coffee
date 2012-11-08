define [
	'jquery'
	'backbone'
	'models/resource'
	'text!templates/visor.hbs'
	'froogaloop2.min'
],($,Backbone,ResourceModel,VisorTPL,F) ->
	class VisorView extends Backbone.View
		el:$('#templating')
		events:
			'mouseenter .rating .star':'ratingON'
			'mouseleave .rating .star':'ratingOFF'
			'click .rating .star':'ratingSet'
			'mouseenter .thi':'showOverlay'
			'mouseleave .thi':'hideOverlay'


		initialize:(@parent) ->
			@tpl = eval(VisorTPL)
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

		