app.directive("widget", ["$compile", function($compile) {

  var linkFn = function(scope, element, attrs) {
   console.log("scope widget");
    // TODO: cleanup, an attribute can't be created in the template with expression
    var elm = element.find(".widget-content");
    //elm.append('<div ' + scope.widget.kind.replace("_", "-") + ' />');
    elm.append('<div graph />');
    $compile(elm)(scope);
   
  };

  return {   
    controller: "WidgetCtrl",
    template: JST["templates/widget/show"],
    link: linkFn
  };
}]);