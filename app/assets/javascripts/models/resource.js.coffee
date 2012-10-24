define [
	'backbone'
],(Backbone) ->
	class Resource extends Backbone.Model
		url:"/resources/visor/#{this.get('id')}"