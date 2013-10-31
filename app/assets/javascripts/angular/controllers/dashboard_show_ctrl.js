app.controller("DashboardShowCtrl", ["$scope", "$rootScope", "$routeParams", "$location", "$timeout", "$window", "Dashboard", "Widget", "UpdateWidget", "Sources", function($scope, $rootScope, $routeParams, $location, $timeout, $window, Dashboard, Widget, UpdateWidget, Sources) {
	
  
  $scope.bookwidget = "widgetpernode";
  $rootScope.resolved = false;   
  $scope.dashboard_id = $routeParams.id;
  
  
  $scope.dashboard = Dashboard.get({ id: $routeParams.id });
  $scope.widgets   = Widget.query({ dashboard_id: $routeParams.id }, function() {	  
    $rootScope.resolved = true;
  }); 
  
  
  $scope.$on('handleBroadcast', function() {
      $scope.widget = UpdateWidget.message;      
      replaceWidget($scope.widget.id, $scope.widget);    
      $scope.sm = UpdateWidget.sm;
  });       
  
  $scope.c_book_name = $routeParams.book;
  //$scope.c_source = _.findWhere($scope.widgets, { name: "graph" }).source
  
  function replaceWidget(id, widget) {    
	    var w = _.findWhere($scope.widgets, { id: widget.id })
	    _.extend(w, widget);
	  } 
  
    //$scope.a_books = [{value:'demo'},{value:'demo1'}];
	$scope.a_books = availableBooks();
	
	function bookMapping(book) {
        return {
          value: book     
        };
      }
     
      function availableBooks() {    	  
        var a_books = $.Books.books;
        return _.compact(_.map(a_books, function(book) {      
        	return bookMapping(book);
        }));	        
      }    
     
      $scope.sm_view = function() {    	 
    	  UpdateWidget.showForBroadcast(false);    		  
      }
      
      if ($routeParams.book != null) {    	  
    	  $scope.widgetpernode = "widgetpernode";
    	  $scope.templateUrl = JST["angular/templates/widget/book_show"];
    	 // $scope.templateUrl = "angular/templates/widget/book_show.html.erb";
      }
  
}]);
