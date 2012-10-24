define [
	'jquery'
	'backbone'
	'jquery.pnotify'
	'views/imagenes'
	'jquery.masonry.min'
],($,Backbone,Notify,ImagenesView,M) ->
	class GeneralView extends Backbone.View
		el:$('#principal')
		events:
			'click #secciones a':'setSeccion'
			'click #botonera a.imagenes, #botonera a.videos':'setSubSeccion'

		initialize: ->
			@render()
		
		setSeccion:(e) =>
			target = $(e.currentTarget)
			target.addClass 'active'
			target.siblings().removeClass 'active'
			window.location.href = target.attr('href')
			

		setSubSeccion:(e) =>
			target = $(e.currentTarget)
			target.toggleClass('active')
			if target.siblings('.active').length == 0
				target.siblings().addClass('active')
			new ImagenesView($('#secciones a.active').attr('data-url'))

		render: =>
			if $('.alerta').length > 0
				$.pnotify
					title:'Dandoo.tv'
					text: $('.alerta').attr('data-text')
					type: $('.alerta').attr('data-type')
					opacity:.8
			container = $('#listado_container')
			container.masonry
				itemSelector:'.item'
				isAnimated:true
				gutterWidth:11
			container.imagesLoaded () ->
				container.fadeIn()
				container.masonry('reload')