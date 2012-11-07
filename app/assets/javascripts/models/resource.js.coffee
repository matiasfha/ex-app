define [
	'backbone'
],(Backbone) ->
	class Resource extends Backbone.Model
		idAttribute:'_id'		
		initialize: ->
			@url = "/resources/#{this.get('id')}"