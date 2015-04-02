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
app.directive("runningbooks", ["RunningBooksModel", function(RunningBooksModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      scope.average = data.average;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return RunningBooksModel.getData(scope.widget,"usermodel").success(onSuccess);
		    }
		    $(".peity_bar_good span").peity("bar", {
				colour : "#459D1C"
			});	
		    scope.init(update);
		  };

  return {
	  template: '<li><div class="left peity_bar_good"><span>2,4,9,7,12,10,12</span>+{{average}}%</div><div class="right"><strong>{{data}}</strong>Apps Running</div></li>',    
      link: linkFn
  };
}]);

