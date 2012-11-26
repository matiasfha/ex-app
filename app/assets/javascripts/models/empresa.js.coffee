define [
	'backbone'
],(Backbone) ->
	class EmpresaModel extends Backbone.Model 
		url:"/empresa"
		idAttribute:'_id'