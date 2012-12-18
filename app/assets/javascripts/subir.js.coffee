#=require jquery
#=require jquery.isotope
#=require File/FileAPI.min
#=require underscore-min
#=require backbone-min
#=require namespace.min
#=require postman.min

#Modulos
#=require helpers/setup
#=require modulos/recursos/subir

$(document).ready () ->
	app = (namespace 'Dandoo')
	new app.Setup()
	new (namespace 'Dandoo.Recursos').Subir()