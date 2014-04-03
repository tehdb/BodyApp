Array.prototype.multisplice = function(){
	var args = arguments[0], //Array.apply(null, arguments),
		res = [];

	args.sort( function(a, b){
 		return a - b;
 	});

	for(var i = 0; i < args.length; i++){
		var index = args[i] - i;
		res.push( this.splice(index, 1)[0] );
	}

	return res;
}
