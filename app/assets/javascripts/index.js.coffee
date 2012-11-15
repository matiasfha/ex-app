require.config
	hbs:
		disableI18n:true
		disableHelpers:true
	shim:
		'combobox':['jquery']
		'foundation/modernizr.foundation':
			exports:'Modernizr'
		'jquery.serializeObject':['jquery']
		'jquery.masonry.min':['jquery']
		'jquery.imagesloaded.min':['jquery']
		'jquery.elastislide':['jquery','modernizr.custom.17475']
		'jquery.cycle.all':['jquery']
		'froogaloop2.min':['jquery']
		'foundation/jquery.foundation.reveal':['jquery']
		'foundation/jquery.placeholder':['jquery']
		'foundation/app':['jquery','foundation/modernizr.foundation','foundation/jquery.placeholder']
		'underscore_hbs':
			exports:'_'
		'handlebars':
			exports:'Handlebars'
		'foundation/jquery.foundation.forms':['jquery']
		
require [
	'jquery'
	'underscore_hbs'
	'backbone'
	'domReady',
	'foundation/modernizr.foundation'
	'handlebars'
	'router'
	'templates/helpers/compare'
	'templates/helpers/iter'
],($,_,Backbone,domReady,M,HR,Router,Compare,Iter) ->
	domReady () ->
		window.Handlebars = HR
		window.$ = $.noConflict()
		#window._ = _.noConflict()
		
		$.fn.reset = ->
			$(this).each () ->
				this.reset()
		
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache: false
		
		# window.notify = (text,type) ->
		# 	$.pnotify
		# 		title:'Dandoo.tv'
		# 		text:text
		# 		type:type 
		# 		opacity:.8



		
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