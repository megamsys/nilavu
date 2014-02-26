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
				  $location.path('/apps');
				};
				
				function changeLocation() {
					  //$scope = $scope || angular.element(document).scope();
					  $route.reload();
					    //$location.path(url).replace();					   
					    //$location.path();
					    //$window.location.href;
					    //$scope.$apply();		 
					};
		} ]);