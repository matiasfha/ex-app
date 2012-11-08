define [
	'backbone'
	'views/general'
	'views/items'
],(Backbone,GeneralView,ItemsView) ->
	class AppRouter extends Backbone.Router 
		routes:
			'':'index'
			'index':'populares'
			'valorados':'valorados'
			'vistos':'vistos'
			'nuevos':'nuevos'
		


		initialize: ->
			new GeneralView()


		index: ->
			$('.secciones a .section.valorados').addClass 'active'
			@itemsView = new ItemsView(false)

		populares: =>
			if @itemsView?
				@itemsView.close()
			@itemsView = new ItemsView('populares')

		valorados: =>
			if @itemsView?
				@itemsView.close()
			@itemsView = new ItemsView('index')
		
		vistos: =>
			if @itemsView?
				@itemsView.close()
			@itemsView = new ItemsView('vistos')

		nuevos: =>	
			
			if @itemsView?
				@itemsView.close()
			@itemsView = new ItemsView('nuevos')
			