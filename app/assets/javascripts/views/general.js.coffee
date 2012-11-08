define [
	'jquery'
	'backbone'
	'jquery.cycle.all'
	'jquery.masonry.min'
	'jquery.imagesloaded.min'
	'views/items'
	'jquery.elastislide'
	'foundation/jquery.foundation.reveal'
	'foundation/jquery.placeholder'
	'foundation/app'
],($,Backbone,C,M,I,ItemsView,ElastiSlide,FR,FP,FA) ->
	class GeneralView extends Backbone.View
		el:$('#principal')
		events:
			'click .secciones a':'setSeccion'
			'click .section.imagenes':'setType'
			'click .section.videos':'setType'

		setSeccion: (e) ->
			target = $(e.currentTarget)
			target.children('.section').addClass 'active'
			target.siblings().children('.section').removeClass 'active'

		setType: (e) ->
			target = $(e.currentTarget)
			target.toggleClass 'active'
			Backbone.history.loadUrl( Backbone.history.fragment )

		initialize: ->
			@render()
		
		masonryLayout: ->
			$('#sub_header').cycle 
				fx:'scrollLeft'
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

		render: =>
			if $('.alerta').length > 0
				notify $('.alerta').attr('data-text'), $('.alerta').attr('data-type')
			c = window.location.href.split('#')[1]
			if c=='index' 
				c = 'favoritos'
			$('.secciones a > .section').removeClass 'active'
			$(".secciones a > .section.#{c}").addClass 'active'

			$('#listado-list').elastislide({orientation:'horizontal'})
			@masonryLayout()