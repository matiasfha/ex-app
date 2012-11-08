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