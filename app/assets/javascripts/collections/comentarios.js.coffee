define [
	'backbone'
	'models/comentario'
],(Backbone,Comentario) ->
	class Comentarios extends Backbone.Model 
		url:"/comments"
		model:Comentario