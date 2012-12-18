Handlebars.registerHelper 'iter', (inicio,fin,options) ->
	ret = ""
	if inicio <= fin 
		for i in [inicio..fin]
			ret = ret + options.fn($.extend({},i,{i:i,iPlus1:i+1}));
	return ret 

Handlebars.registerHelper 'compare', (lvalue, rvalue, options)  ->
	if  arguments.length < 3
       	throw new Error("Handlerbars Helper 'compare' needs 2 parameters")
	operator = options.hash.operator || "=="
	operators = 
		'==':      (l,r)  -> l == r
		'!=':      (l,r) ->   l != r
		'<':       (l,r) ->   l < r 
		'>':       (l,r) ->   l > r;
		'<=':      (l,r) ->   l <= r
		'>=':      (l,r) ->   l >= r 
		'typeof':   (l,r) ->   typeof l == r

	if  !operators[operator]
		throw new Error("Handlerbars Helper 'compare' doesn't know the operator "+operator);
	result = operators[operator](lvalue,rvalue);
	if result
		options.fn(this)
	else
		options.inverse(this)