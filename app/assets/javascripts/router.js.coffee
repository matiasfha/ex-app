define [
	'jquery'
	'backbone'
	'views/general'
	'views/imagenes'
],($,Backbone,GeneralView,ImagenesView) ->
	class Router extends Backbone.Router 
		routes:
			'':'index'
			'index':'valorados'
			'populares':'populares'
			'vistos':'vistos'
			'nuevos':'nuevos'

		initialize: ->
			new GeneralView()
			
		index: =>
			if $('.item').length <= 0
				$('#b_nuevos').trigger 'click'
		
		valorados: =>
			$('#b_valorados').addClass 'active'
			$('#b_valorados').siblings().removeClass('active')
			if @imagenesView?
				@imagenesView.close()
			@imagenesView = new ImagenesView($('#b_valorados').attr('data-url'))
 
		populares: =>
			$('#b_populares').addClass 'active'
			$('#b_populares').siblings().removeClass('active')
			if @imagenesView?
				@imagenesView.close()
			@imagenesView = new ImagenesView($('#b_populares').attr('data-url'))

		vistos: =>
			$('#b_vistos').addClass 'active'
			$('#b_vistos').siblings().removeClass('active')
			if @imagenesView?
				@imagenesView.close()
			@imagenesView = new ImagenesView($('#b_vistos').attr('data-url'))

		nuevos: =>
			$('#b_nuevos').addClass 'active'
			$('#b_nuevos').siblings().removeClass('active')
			if @imagenesView?
				@imagenesView.close()
			@imagenesView = new ImagenesView($('#b_nuevos').attr('data-url'))