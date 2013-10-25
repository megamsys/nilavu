app.directive("widgetpernode", ["$compile", function($compile) {
	
  var linkFn = function(scope, element, attrs) {
   console.log("scope widget"+scope.widget.kind);
   if (scope.widget.widget_type == "pernode" && scope.widget.name == "graph") {
    // TODO: cleanup, an attribute can't be created in the template with expression
    var elm = element.find(".widget_content");
    //elm.append('<div ' + scope.widget.kind.replace("_", "-") + ' />');
    elm.append('<div '+ scope.widget.name + ' />');
    $compile(elm)(scope);
   }
   
  };

  return {   
    controller: "WidgetCtrl",
    template: JST["angular/templates/widget/show"],
    link: linkFn
  };
	
}]);
