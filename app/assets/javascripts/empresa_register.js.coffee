require.config
	shim:
		'jquery.masonry.min':['jquery']
		'jquery.imagesloaded.min':['jquery']
		'froogaloop2.min':['jquery']
		'underscore_hbs':
			exports:'_'
		'handlebars':
			exports:'Handlebars'
		'File/FileAPI.min':
			exports:'FileAPI'
		'jquery.serializeObject':['jquery']
		'modernizr.custom.17475':
			exports:'Modernizr'
	
		
require [
	'jquery'
	'underscore_hbs'
	'backbone'
	'domReady',
	'handlebars'
	'templates/helpers/compare'
	'templates/helpers/iter'
	'router_empresa_register'
	'modernizr.custom.17475'
],($,_,Backbone,domReady,HR,Compare,Iter,Router,M) ->
	domReady () ->
		window.Handlebars = HR
		window.$ = $.noConflict()
		
		Modernizr.load
			test:Modernizr.input.placeholder
			nope:[
				'/assets/placeholder_polyfill.min.css'
				'/assets/placeholder_polyfill.jquery.min.combo.js'
			]

		$.fn.reset = ->
			$(this).each () ->
				this.reset()
		
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache:false

		String.prototype.toHHMMSS = () ->
			sec_numb    = parseInt(this)
			hours   = Math.floor(sec_numb / 3600)
			minutes = Math.floor((sec_numb - (hours * 3600)) / 60)
			seconds = sec_numb - (hours * 3600) - (minutes * 60)

			if hours   < 10
				hours   = "0"+hours
			if minutes < 10
				minutes = "0"+minutes
			if seconds < 10
				seconds = "0"+seconds
			time    = hours+':'+minutes+':'+seconds;

		
		new Router()
		Backbone.history.start()