define [
	'jquery'
	'backbone'
	'jquery.masonry.min'
	'jquery.imagesloaded.min'
	'views/items'
	'foundation/jquery.foundation.reveal'
],($,Backbone,M,I,ItemsView,R) ->
	class AppRouter extends Backbone.Router 
		
		routes:
			'ranks':'showRanks'
			'favs':'showFavs'
			'tema':'showTema'
			'subir':'showSubir'

		initialize: ->
			if @itemsView?
				@itemsView.close()
			@itemsView = new ItemsView()
			@masonryLayout()
			$('.tuerca1,.tuerca2').on 'click',@clickTuercas

		clickTuercas:(e) ->
			if !$('.tuerca1').hasClass 'active'
				$('.menu').show()
			else
				$('.menu').hide()
			$('.tuerca1').toggleClass 'active'
			$('.tuerca2').toggleClass 'active'

		masonryLayout: ->
			container = $('#listado_container')
			gutter = 17
			if $(window).width() <= 1024
				gutter =11
			if $(window).width() <= 800
					gutter = 0;

			container.imagesLoaded () ->
				container.masonry
					itemSelector:'.item'
					isAnimated:!Modernizr.csstransitions
					gutterWidth:gutter
				container.fadeIn()	
				container.masonry('reload')

			$(window).resize (e) ->
				container.fadeOut().stop()
				gutter = 25
				if $(window).width() <= 1024
					gutter = 11
				if $(window).width() <= 800
					gutter = 0;
				container.masonry 'option',{gutterWidth:gutter}	
				container.masonry 'reload'
				container.fadeIn().stop()

		showRanks: =>
			if @itemsView?
				@itemsView.close()
			$('#perfil').fadeOut()
			$('.perfil,.favs,.salir,.tema').removeClass 'active'
			$('.ranks').addClass 'active'
			@itemsView = new ItemsView 'ranks',$('#user_id').val()
			
		showFavs:  =>
			if @itemsView?
				@itemsView.close()
			$('#perfil').fadeOut()
			$('.perfil,.ranks,.salir,.tema').removeClass 'active'
			$('.favs').addClass 'active'
			@itemsView = new ItemsView 'favs',$('#user_id').val()
			
		showTema: ->

		subir: ->
		