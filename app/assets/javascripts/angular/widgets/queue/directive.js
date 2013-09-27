app.directive("queue", ["QueueModel", function(QueueModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return QueueModel.getData("demo").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="span4 center"><ul class="site-stats"><li><i class="icon-user"></i><strong>{{data}}</strong><small>Total Queue Messages</small></li></ul></div>',    
      link: linkFn
  };
}]);








