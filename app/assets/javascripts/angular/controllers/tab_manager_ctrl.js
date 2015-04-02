/* 
** Copyright [2013-2015] [Megam Systems]
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/
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
