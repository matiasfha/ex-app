define [
	'jquery'
	'backbone'
],($,Backbone) ->
	class EmpresaView extends Backbone.Router
		el:$('#empresas')
		events:
			'click #go_paso2','mostrarContacto'
		initialize: (@paso) ->
			@render()

		render: =>
			$('.contenedor.steps.active').animate {marginLeft:'-500px',opacity:0},'slow',() =>
				$('.contenedor.steps.active').hide().removeClass 'active'
				$("##{@paso}").animate({marginLeft:'0px',opacity:'toggle'}).addClass 'active'
				switch @paso
					when 'paso1'
						p = $('#p1')
					when 'paso2'
						p = $('#p2')
					when 'paso3'
						p = $('#p3')
					when 'paso4'
						p = $('#p4')
				p.addClass('paso-on').removeClass('paso-off')		
		
		mostrarContacto: (e) ->
			nombre = $('#empresa_nombre').val()
			nombre_legal = $('#empresa_nombre_legal').val()
			rut = $('#empresa_rut').val()
			rubro = $('#empresa_rubro_id').find(':selected').val()
			pais = $('#empresa_country_id').find(':selected').val()