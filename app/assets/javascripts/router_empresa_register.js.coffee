define [
	'jquery'
	'backbone'
	'views/empresa/paso'
],($,Backbone,Paso) ->
	class RouterEmpresa extends Backbone.Router
		routes:
			'paso1':'paso1'
			'paso2':'paso2'
			'paso3':'paso3'
			'paso4':'paso4'

		initialize: ->
			#new Paso('paso1')

		paso1: ->
			new Paso('paso1')

		paso2: ->
			new Paso('paso2')

		paso3: ->
			new Paso('paso3')

		paso4: ->
			new Paso('paso4')