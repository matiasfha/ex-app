define [
	'backbone'
],(Backbone) ->
	class Comentario extends Backbone.Model 
		url:"/comments"
		idAttribute:'_id'		
