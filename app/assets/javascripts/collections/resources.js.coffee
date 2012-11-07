define [
	'backbone'
	'models/resource'
],(Backbone,ResourceModel) ->
	class Resources extends Backbone.Collection 
		url:'/resources/listado'
		model:ResourceModel