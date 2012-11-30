( ($) ->
	$.fn.rutValidate = (dv) ->
		rut = $(this).val()+"-"+dv
		if rut.length<9
			false
		i1 = rut.indexOf("-")
		dv = rut.substr(i1+1).toUpperCase()
		nu = rut.substr(0,i1)
		cnt=0
		suma=0
		i = nu.length - 1
		while i >= 0
		  dig=nu.substr(i,1)
		  fc =cnt+2
		  suma += parseInt(dig)*fc
		  cnt =(cnt+1) % 6
		  i--
		dvok= 11 - (suma%11)
		if dvok==11 
			dvokstr=0
		if dvok=="0"
			dvokstr="K"
		if ((dvok!=11) && (dvok!=10))
			dvokstr=""+dvok
		if dvokstr==dv 
			true
		else
			false


)(jQuery)