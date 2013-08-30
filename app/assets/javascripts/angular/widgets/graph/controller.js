app.controller("GraphCtrl", function($scope) {
	console.log("controller entry");
	var data1 = [ [ [ 0, 1 ], [ 1, 5 ], [ 2, 2 ] ] ], data2 = [ [ [ 0, 4 ],
			[ 1, 2 ], [ 2, 4 ] ] ], curr = 1;

	$scope.data = data1;

	$scope.change = function() {
		if (curr === 1) {
			$scope.data = data2;
			curr = 2;
		} else {
			$scope.data = data1;
			curr = 1;
		}
	};

});