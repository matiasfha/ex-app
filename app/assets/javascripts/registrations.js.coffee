$(document).ready () ->

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
 	

