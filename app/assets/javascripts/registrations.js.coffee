$(document).ready () ->

	$('select').combobox()


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
	

	$('#user_country').change (e) ->
		country = $('#user_country :selected').val()
		if country?
			populate_select "/metadata/get_states/#{country}", $('#user_state')
		
				

	$('#user_state').live 'change',(e) ->
		state = $('#user_state :selected').val()
		if state?
			populate_select "/metadata/get_communes/#{state}",$('#user_commune')
				

	$('#user_commune').live 'change',(e)->
		commune = $('#user_commune :selected').val()
		if commune?
			populate_select "/metadata/get_cities/#{commune}",$('#user_city')
 	
	$('input#commit').live 'click',(e) ->
		$('form').submit()

