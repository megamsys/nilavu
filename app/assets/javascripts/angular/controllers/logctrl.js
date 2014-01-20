function LogCtrl($scope, logsocket, $location, LogStackLimit) {
	$scope.logs = [];
	$scope.total = 0;
	$scope.l_total = 0;
	$scope.prog_bar = "visibility:hidden";
	$scope.bookName = "Select one book name";
	$scope.sendmessage = function(data) {
		//socket.disconnect();
		$scope.prog_bar = "";
		$scope.bookName = data;	
		//socket.connect();		
		logsocket.emit('message', data);
	};

	logsocket.on('connect', function(data) {

	});

	
	logsocket.on('disconnect', function(event) {
		logsocket.disconnect();

	});

	logsocket.on('message', function(message) {
		alert("===> TEST MESSAGE <===");
		$scope.prog_bar = "visibility:hidden";
		$scope.total = $scope.total + 1;
		$scope.l_total = $scope.l_total + 1;
		var replaceChar = message.logs.replace(/\@/g, "");
		var parse = JSON.parse(replaceChar);
		$scope.source = parse.source;
		$scope.logs.push(LogStackLimit.push(parse));
		if ($scope.total > 100) {
			$scope.logs = [];
			$scope.total = 0;
		}
		predicate = 'timestamp';
	});
	$scope.book_json = 'http://mob.co/kibana/#/dashboard/.json';
};


