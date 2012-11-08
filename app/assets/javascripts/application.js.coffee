require [
	'jquery'
	'underscore'
	'backbone'
	'domReady',
	'modernizr-2.6.1-respond-1.1.0.min'
	'handlebars.runtime'
	'router'
	'jquery.pnotify'
],($,_,Backbone,domReady,M,H,Router,N) ->
	domReady () ->
		
		window.$ = $.noConflict()
		window.jQuery = window.$
		window._ = _.noConflict()
		
		$.fn.reset = ->
			$(this).each () ->
				this.reset()
		
		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
		
		window.notify = (text,type) ->
			$.pnotify
				title:'Dandoo.tv'
				text:text
				type:type 
				opacity:.8


		#Handlebars helpers

		Handlebars.registerHelper 'iter', (inicio,fin,options) ->
			ret = ""
			if inicio <= fin 
				for i in [inicio..fin]
					ret = ret + options.fn(_.extend({},i,{i:i,iPlus1:i+1}));
			return ret 

		Handlebars.registerHelper 'compare', (lvalue, operator, rvalue, options) ->
			if arguments.length < 3
		        throw new Error("Handlerbars Helper 'compare' needs 2 parameters");
		    if options == undefined
		        options = rvalue;
		        rvalue = operator;
		        operator = "==";
		    operators = 
		        '==': 	(l, r) -> l == r
		        '!=': 	(l, r) -> l != r
		        '<': 	(l, r) -> l < r
		        '>': 	(l, r) -> l > r
		        '<=': 	(l, r) -> l <= r
		        '>=': 	(l, r) -> l >= r
		        'typeof': (l, r) -> typeof l == r
		   	if !operators[operator]
		        throw new Error("Handlerbars Helper 'compare' doesn't know the operator " + operator);
		    result = operators[operator](lvalue, rvalue)
		    if result
		        options.fn(this);
		    else
		        options.inverse(this);
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