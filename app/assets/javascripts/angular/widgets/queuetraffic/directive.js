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








