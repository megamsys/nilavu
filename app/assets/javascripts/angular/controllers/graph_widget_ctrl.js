app.controller("GraphWidgetCtrl", ["$scope", "GraphWidgetService", function($scope, GraphWidgetService) {
			$scope.availableNodes = [];
			$scope.availableNodes = [ 'demo', 'book1', 'book2' ];

			var data1 = [ [ [0, 0], [1, 22], [10, 4], [11, 61], [4, 8] ] ], data2 = [ [
					[ 0, 4 ], [ 1, 2 ], [ 2, 41 ] ] ], curr = 1;

			$scope.changeNode = function(node) {
				var a = GraphWidgetService.getData(node);
				console.log(a);
			}
			
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

		} ]);