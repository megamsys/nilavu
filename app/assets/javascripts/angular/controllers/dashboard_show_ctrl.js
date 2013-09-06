app.controller("DashboardShowCtrl", ["$scope", "$rootScope", "$routeParams", "$location", "$timeout", "$window", "Dashboard", "Widget", function($scope, $rootScope, $routeParams, $location, $timeout, $window, Dashboard, Widget) {

  $rootScope.resolved = false;
  console.log("----------d-show controller"+$routeParams.id);
  $scope.dashboard = Dashboard.get({ id: $routeParams.id });
  $scope.widgets   = Widget.query({ dashboard_id: $routeParams.id }, function() {
	  console.log("===");
	  
    $rootScope.resolved = true;
  });

    
}]);
