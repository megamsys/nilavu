app.controller("GraphWidgetCtrl", ["$scope", "$timeout", "GraphWidgetService", function($scope, $timeout, GraphWidgetService) {

    $scope.availableNodes = [];
	$scope.availableNodes = [ 'demo', 'demo1', 'book2' ];

	var data1 = [ [ [0, 0], [1, 22], [10, 4], [11, 61], [4, 8] ] ], data2 = [ [
			[ 0, 4 ], [ 1, 2 ], [ 2, 41 ] ] ], curr = 1;
	$scope.data = data1;
  
	$scope.changeNode = function(node) {
		 var sourceNode = node;
		    $timeout(function() { myFunction(sourceNode); }, 500);
		//$scope.onTimeout(node);			
	}
	myFunction = function(node) {
		var a = GraphWidgetService.getData(node);
		$scope.data = a;
	}
	    //$scope.onTimeout = function(node){
	    //	var sourceNode = node;
	    //	var a = GraphWidgetService.getData(sourceNode);
		//	$scope.data = a;	
	     //   mytimeout = $timeout($scope.onTimeout,3000);
	  //  }
	   // var mytimeout = $timeout($scope.onTimeout,10);    
	    
	   
}]);



