app.directive("uptime", ["UptimeModel", function(UptimeModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return UptimeModel.getData("demo").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="col-xs-4 center" id="uptime"><ul class="site-stats"><li><i class="icon-user"></i><strong>{{data}}</strong><small>Total Uptime(days)</small></li></ul></div>',    
      //template: '<i class="icon-tag"></i><strong>{{data}}</strong><small>Total Uptime(days)</small>',
	  link: linkFn
  };
}]);








