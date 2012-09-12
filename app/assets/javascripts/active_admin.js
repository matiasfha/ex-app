//= require active_admin/base
$(document).ready (function(){
	var populate_select = function(url,element){
		$.getJSON(url,function(data){
			var item,options, _i, _len;
			options = '<option>Seleccione</option>';
			for(_i=0,_len = data.length;_i<_len;_i++){
				item = data[_i];
				options +="<option value=\""+item._id+"\">"+item.nombre+"</option>";
			}
			element.html(options)
		});
			
	}

	$('#user_country_id').change(function(e){
		var country = $('#user_country_id :selected').val();
		if (country!==null){
			populate_select("/metadata/get_states/"+country, $('#user_state_id'));
		}
	});
				

	$('#user_state_id').live('change',function(e){
		var state = $('#user_state_id :selected').val();
		if (state!==null){
			populate_select("/metadata/get_communes/"+state,$('#user_commune_id'));
		}
	});
				

	$('#user_commune_id').live('change',function(e){
		var commune = $('#user_commune_id :selected').val();
		if( commune!==null){
			populate_select("/metadata/get_cities/"+commune,$('#user_city_id'));
		}
	});
		
}); 

	

	

	