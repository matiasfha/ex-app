//= require active_admin/base
$(document).ready () ->

	

	populate_select = (url,element) ->
		$.getJSON url,(data) ->
			options = '<option>Seleccione</option>'
			for item in data 
				options+="""<option value="#{item._id}">#{item.nombre}</option>"""
			element.html(options)

	$('#user_country_id').change (e) ->
		country = $('#user_country_id :selected').val()
		if country?
			populate_select "/metadata/get_states/#{country}", $('#user_state_id')
				

	$('#user_state_id').live 'change',(e) ->
		state = $('#user_state_id :selected').val()
		if state?
			populate_select "/metadata/get_communes/#{state}",$('#user_commune_id')
				

	$('#user_commune_id').live 'change',(e) ->
		commune = $('#user_commune_id :selected').val()
		if commune?
			populate_select "/metadata/get_cities/#{commune}",$('#user_city_id')