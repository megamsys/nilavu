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
app.directive("cumulativeuptime", ["CumulativeUptimeModel", function(CumulativeUptimeModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return CumulativeUptimeModel.getData("demo").success(onSuccess);
		    }
		    
		    $(".peity_bar_neutral span").peity("bar", {
				colour : "#757575"
			});
		    scope.init(update);
		  };

  return {
	  template: '<li><div class="left peity_bar_neutral"><span>20,15,18,14,10,9,9,9</span>99.3%</div><div class="right"><strong>{{data}}</strong>Apps Uptime(days.hrs)</div></li>',              
      link: linkFn
  };
}]);








