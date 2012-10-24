define [
	'backbone'
	'models/resource'
],(Backbone,ResourceModel) ->
	class Resources extends Backbone.Collection 
		model:ResourceModel