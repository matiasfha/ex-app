#=require jquery
#=require jquery.isotope
#=require froogaloop2.min
#=require jquery.infinitescroll.min
#=require dropdown
#=require jquery.serializeObject
#=require underscore-min
#=require backbone-min
#=require namespace.min
#=require postman.min

#Templates
#=require handlebars.runtime
#=require helpers/handlebars
#=require templates/show.hbs
#=require templates/comentario.hbs

#Carga de modulos
#=require modulos/grilla
#=require modulos/feedback

(namespace 'Dandoo').VERSION = 1.0


class (namespace 'Dandoo').Setup
	resetForm:  =>
		$.fn.reset = ->
			$(this).each () ->
				this.reset 
	ajaxSetup: =>
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache: true
	constructor: ->
		@resetForm()
		@ajaxSetup()






$(document).ready () ->
	app = (namespace 'Dandoo')
	new app.Setup()
	new app.Grilla()
	# new app.Feedback()
	
	# postman.receive 'modal-activo',() ->
	# 	new app.Modal()
		