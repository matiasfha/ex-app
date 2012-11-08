define('templates/helpers/iter',['handelbars'],(Handlebars) ->
	Handlebars.registerHelper 'iter', (inicio,fin,options) ->
		ret = ""
		if inicio <= fin 
			for i in [inicio..fin]
				ret = ret + options.fn(_.extend({},i,{i:i,iPlus1:i+1}));
		return ret 
