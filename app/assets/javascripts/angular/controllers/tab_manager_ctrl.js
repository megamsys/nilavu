app.controller('TabManagerCtrl', ['$scope', function($scope) {

	 $scope.tabManager = {};

	    $scope.tabManager.tabItems = [];
	    
	    $scope.tabManager.checkIfMaxTabs = function(){
	        var max = 4;
	        var i = $scope.tabManager.tabItems.length;
	        if(i > max){
	            return true;
	        }
	        return false;
	    };

	    $scope.tabManager.getTitle = function(tabInfo){
	        console.log("[ title ] -> ",tabInfo.title);
	        tabInfo.title.substr(0,10);
	    };

	    $scope.tabManager.resetSelected = function(){
	        angular.forEach($scope.tabManager.tabItems, function(pane) {
	            pane.selected = false;
	        });
	    };

	    
	    $scope.tabManager.addTab = function(node){
	    	alert($scope.tabManager.tabItems.length);
	        if($scope.tabManager.checkIfMaxTabs()){
	            alert("[Max Tabs] You have opened max tabs for this page.");
	            return;
	        }
	        $scope.tabManager.resetSelected();	       
	        	var i = ($scope.tabManager.tabItems.length +1);
		        $scope.tabManager.tabItems.push({
		            title: node,	            
		            selected: true		       
	        });       
	        
	    };
	    
	    //to select the tab
	    $scope.tabManager.select = function(i) {
	        angular.forEach($scope.tabManager.tabItems, function(tabInfo) {
	            tabInfo.selected = false;
	        });
	        $scope.tabManager.tabItems[i].selected = true;
	    }
	   

}]);