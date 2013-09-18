app.controller("WidgetPerNodeCtrl", ["$scope", "UpdateWidget", "Sources", function($scope, UpdateWidget, Sources) {
	
	$scope.sources = Sources.availableSources($scope.widget.kind);
	
	 $scope.update_widget_range = function(updatetime, widget) {
		 widget.settings = updatetime;
		 widget.$update;
		 UpdateWidget.prepForBroadcast(widget);
	    };	        
	   
	    $scope.update_widget_source = function(updatesource, widget) {
			 widget.source = updatesource;
			 widget.$update;
			 UpdateWidget.prepForBroadcast(widget);
		    };	 
	    
	    $scope.$on('handleBroadcast', function() {
	        $scope.message = UpdateWidget.message;
	    });     
}]);