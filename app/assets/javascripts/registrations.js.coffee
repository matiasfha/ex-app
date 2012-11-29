
require.config
	shim:
		'jquery-ui-1.9.1.custom.min':['jquery']
		'foundation/jquery.foundation.forms':['jquery']
		
		
require [
	'jquery'
	'domReady'
	'jquery-ui-1.9.1.custom.min'
	'foundation/jquery.foundation.forms'
],($,domReady,UI,F) ->
	domReady () ->
		$(document).foundationCustomForms();

		$('.error').focus (e) ->
			$(e.currentTarget).parent().removeClass('error')

		$('.date').datepicker
			firstDay:1
			monthNames:['Enero','Febrero','Marzo','Abril','Mayo','Junio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
			monthNamesShort:['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']
			dayNames:['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sabado']
			dayNamesMin:['Do','Lu','Ma','Mi','Ju','Vi','Sa']
			dayNamesShort:['Dom','Lun','Mar','Mie','Jue','Vie','Sab']
			dateFormat:'dd/mm/yy'
		
		populate_select = (url,element) ->
			$.getJSON url, (data) ->
				options = '<option>Seleccione</option>'
				for item in data
					options +="<option value=\""+item._id+"\">"+item.nombre+"</option>";
				element.html(options)
				element.foundationCustomForms();
		

		$('#usuario_country_id').change (e) ->
			country = $('#usuario_country_id :selected').val()
			if country?
				populate_select "/metadata/get_states/#{country}", $('#usuario_state_id')
			
					

		$('#usuario_state_id').live 'change',(e) ->
			state = $('#usuario_state_id :selected').val()
			if state?
				populate_select "/metadata/get_communes/#{state}",$('#usuario_commune_id')
					

		$('#usuario_commune_id').live 'change',(e)->
			commune = $('#usuario_commune_id :selected').val()
			if commune?
				populate_select "/metadata/get_cities/#{commune}",$('#usuario_city_id')
			
		$('input#commit').live 'click',(e) ->
			e.stopPropagation()
			e.preventDefault()
			data = $('form').serialize()
			
			$.post '/authentications',data,(response) ->
				if response.success == true
					window.location.href = '/'
				else
					if response.mensaje == 'vacios'
						for campo,value of response.campos
							$("#usuario_#{campo}").parent().addClass('error')
					

		

