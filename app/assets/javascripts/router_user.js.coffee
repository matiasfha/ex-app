define [
	'backbone'
	'views/general'
],(Backbone,GeneralView) ->
	class AppRouter extends Backbone.Router 
		


		initialize: ->
			new GeneralView()


		