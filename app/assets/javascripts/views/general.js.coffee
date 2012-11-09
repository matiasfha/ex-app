define [
	'jquery'
	'backbone'
	'jquery.cycle.all'
	'jquery.masonry.min'
	'jquery.imagesloaded.min'
	'views/items'
	'jquery.elastislide'
	'foundation/app'
	'foundation/jquery.foundation.reveal'
	'foundation/jquery.placeholder'	
],($,Backbone,C,M,I,ItemsView,ElastiSlide,FA,FR,FP) ->
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

		clickTuercas:(e) ->
			if !$('.tuerca1').hasClass 'active'
				$('.menu').show()
			else
				$('.menu').hide()
			$('.tuerca1').toggleClass 'active'
			$('.tuerca2').toggleClass 'active'

		initialize: ->
			$('.tuerca1,.tuerca2').on 'click',@clickTuercas
			$('#feedback .tab').on 'click',(e) ->
				if $(e.currentTarget).hasClass 'active'
					top = '96%'
				else
					top = '68%'
				$('#feedback').animate({top:top})			
				$(e.currentTarget).toggleClass 'active'	
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
			# if $('.alerta').length > 0
			# 	notify $('.alerta').attr('data-text'), $('.alerta').attr('data-type')
			c = window.location.href.split('#')[1]
			if c=='index' 
				c = 'favoritos'
			$('.secciones a > .section').removeClass 'active'
			$(".secciones a > .section.#{c}").addClass 'active'

			$('#listado-list').elastislide({orientation:'horizontal'})
			@masonryLayout()