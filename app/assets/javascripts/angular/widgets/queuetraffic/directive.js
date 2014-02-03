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
		    	
		    	//tooltip for peity charts
		    	/*$('.popover-tickets').popover({
			        placement: 'bottom',
			        content: '<span class="content-big">2968</span> <span class="content-small">All Tickets</span><br /><span class="content-big">48</span> <span class="content-small">New Tickets</span><br /><span class="content-big">495</span> <span class="content-small">Solved</span>',
			        trigger: 'hover',
			        html: true   
			     });*/
	        }, 0);
		    
		    scope.init(update);
		  };

  return {
	  template: '<li class="popover-tickets"><div class="left peity_line_good"><span>12,6,9,23,14,10,17</span>+70%</div><div class="right"><strong>{{data}}</strong>Queue Traffic</div></li>',    
      link: linkFn
  };
}]);








