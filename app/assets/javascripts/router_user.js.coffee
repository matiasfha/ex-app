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
			$('#perfil').remove()
			$('.perfil,.favs,.salir,.tema').removeClass 'active'
			$('.ranks').addClass 'active'
			@itemsView = new ItemsView('ranks','5078712d2b091eb4d7000021')
			
		showFavs:  =>
			if @itemsView?
				@itemsView.close()
			$('#perfil').remove()
			$('.perfil,.ranks,.salir,.tema').removeClass 'active'
			$('.favs').addClass 'active'
			@itemsView = new ItemsView('favs','5078712d2b091eb4d7000021')
			
		showTema: ->

		subir: ->
		