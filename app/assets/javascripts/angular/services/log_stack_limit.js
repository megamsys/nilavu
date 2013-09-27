app.factory("LogStackLimit", function($timeout) {
	var i = 0;
	var l = [];
	function push(message) {
		i = i + 1;
		if (i <= 100) {
			console.log("limit"+i);
			l.push(message);
			return l.pop();
		} else {
			console.log("unlimit"+i);			
			//$timeout(function() {
				//console.log("timeout");
			for(var j=0; j<=100; j++) {
			  l.splice(j, 1);
			}
				i = 0;
				l=[];
			//}, 3000);
		}
	}
	return {
		push : push
	};
});