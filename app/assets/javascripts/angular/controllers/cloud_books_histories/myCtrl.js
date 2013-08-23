function MyCtrl($scope, socket) {	
	$scope.logs = [];
	$scope.logerrors = [];
	$scope.sendmessage = function(data) {
		alert("connect");
		socket.emit('message', data)
	};

	socket.on('connect', function(data) {

	});

	socket.on('disconnect', function(event) {
		socket.removeAllListeners();
		alert("disconnect");	
	});

	socket.on('message', function(message) {	
		var replaceChar = message.replace(/\@/g, "");
		var parse = JSON.parse(replaceChar);		
		$scope.source = parse.source;					
		$scope.logs.push(parse);
		$scope.predicate = 'timestamp';		
		
		/*if((parse.message).indexOf("INFO") == 0){
			$scope.mycolor = 'log_info';				
		}
		if((parse.message).indexOf("ERROR") == 0){
			$scope.mycolor = 'log_error';			
		}
		/*if((parse.message).indexOf("WARN") == 0){
			$scope.mycolor = 'log_warn';
		}
		if((parse.message).indexOf("INFO") && (parse.message).indexOf("ERROR") && (parse.message).indexOf("WARN") != 0){
			$scope.mycolor = 'log_info';
		}		*/
	});
};

