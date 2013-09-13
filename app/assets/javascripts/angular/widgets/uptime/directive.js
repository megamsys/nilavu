app.directive("uptime", ["UptimeModel", function(UptimeModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return UptimeModel.getData("ganglia").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="span4"><ul class="site-stats"><li><i class="icon-user"></i><strong>{{data}}</strong><small>Total Uptime(days)</small></li></ul></div>',    
      link: linkFn
  };
}]);








