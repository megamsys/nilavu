app.controller("MainCtrl", [ "$scope", "$rootScope", "$location",
		function($scope, $timeout, $location) {
			function LocationController($scope, $location) {
				$scope.$watch('locationPath', function(path) {
					$location.path(path);
				});
				$scope.$watch(function() {
					return $location.path();
				}, function(path) {
					$scope.locationPath = path;
				});
			}
			 $scope.go = function ( path ) {
				 console.log("location");
				  $location.path('/cloud_books');
				};
				
				function changeLocation() {
					  $scope = $scope || angular.element(document).scope();
					    //only use this if you want to replace the history stack
					    //$location.path(url).replace();

					    //this this if you want to change the URL and add it to the history stack
					    $location.path();
					    $scope.$apply();		 
					};
		} ]);