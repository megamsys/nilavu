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
app.directive("widgetpercontainer", ["$compile", function($compile) {
	
  var linkFn = function(scope, element, attrs) {
   console.log("scope widget"+scope.widget.kind);
   
    // TODO: cleanup, an attribute can't be created in the template with expression
    var elm = element.find(".widget_content");
    elm.append('<div container />');
    $compile(elm)(scope);
   
  };

  return {   
    controller: "WidgetCtrl",
    templateUrl: 'angular/templates/widget/show.html.erb',
    link: linkFn
  };
	
}]);
