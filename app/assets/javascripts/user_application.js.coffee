#=require jquery
#=require jquery.numeric
#=require File/FileAPI.min
#=require jquery.serializeObject
#=require jquery-ui-1.9.2.custom.min
#=require underscore-min
#=require backbone-min
#=require namespace.min
#=require jquery.isotope

#Modulos
#=require helpers/setup
#=require modulos/user/register



$(document).ready () ->
	app = (namespace 'Dandoo')
	new app.Setup()
	new (namespace 'Dandoo.User').Register()