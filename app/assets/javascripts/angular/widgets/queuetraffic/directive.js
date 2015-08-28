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
app.directive("queuetraffic", ["QueueTrafficModel", "$timeout", function(QueueTrafficModel, $timeout) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return QueueTrafficModel.getData("demo").success(onSuccess);
		    }
		    $timeout(function() { 		    	
		    	$(".peity_line_good span").peity("line", {
				colour : "#B1FFA9",
				strokeColour : "#459D1C"
			    }); 		    	
		    	
	        }, 0);
		    
		    scope.init(update);
		  };

  return {
	  template: '<div class="left peity_line_good"><span>12,6,9,23,14,10,17</span>+70%</div><div class="right"><strong>{{data}}</strong>Web Traffic</div>',    
      link: linkFn
  };
}]);








