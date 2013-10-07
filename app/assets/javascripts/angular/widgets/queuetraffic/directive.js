app.directive("queuetraffic", ["QueueTrafficModel", function(QueueTrafficModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return QueueTrafficModel.getData("demo").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="span4 center"><ul class="stat-boxes"><li class="popover-tickets"><div class="left peity_line_good"><span>12,6,9,23,14,10,17</span>+70%</div><div class="right"><strong>{{data}}</strong>Queue Traffic</div></li></ul></div>',    
      link: linkFn
  };
}]);








