( ($) ->
	$.fn.numeric = () ->
		$(this).keydown (e) ->
			if e.keyCode == 46 || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 27 || e.keyCode == 13 || (e.keyCode == 65 && e.ctrlKey == true) ||  (e.keyCode >= 35 && e.keyCode <= 39) 
                 return
        	else
        		if e.shiftKey || (e.keyCode < 48 || e.keyCode > 57) && (e.keyCode < 96 || e.keyCode > 105 )
	                e.preventDefault(); 
	            
)(jQuery)			