define [
	'jquery'
	'backbone'
	'modelos/resource'
	'text!templates/home/visor.hbs'
],($,Backbone,ResourceModel,Template) ->
	class VisorView extends Backbone.View 
		el:$('#templating')
		initialize:(@resource_id) ->
			@tpl = eval(Template)
			@resource = new ResourceModel {id:@resource_id}
			@resource.on 'change', @render
			@resource.fetch()

		render: =>
			$(@el).html @tpl(@resource.toJSON())
			$('#visor').modal 'show'
