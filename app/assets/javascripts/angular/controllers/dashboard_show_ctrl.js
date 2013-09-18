app.controller("DashboardShowCtrl", ["$scope", "$rootScope", "$routeParams", "$location", "$timeout", "$window", "Dashboard", "Widget", "UpdateWidget", function($scope, $rootScope, $routeParams, $location, $timeout, $window, Dashboard, Widget, UpdateWidget) {

  $rootScope.resolved = false;
  console.log("----------d-show controller"+$routeParams.id);
  $scope.dashboard = Dashboard.get({ id: $routeParams.id });
  $scope.widgets   = Widget.query({ dashboard_id: $routeParams.id }, function() {
	  console.log("===");	 
    $rootScope.resolved = true;
  }); 
  $scope.$on('handleBroadcast', function() {
      $scope.widget = UpdateWidget.message;
      replaceWidget($scope.widget.id, $scope.widget);            
  });       
  
  function replaceWidget(id, widget) {    
	    var w = _.findWhere($scope.widgets, { id: widget.id })
	    _.extend(w, widget);
	  }
  
  
}]);
