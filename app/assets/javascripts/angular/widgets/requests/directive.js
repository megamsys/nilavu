app.directive("requests", ["FlotrGraphHelper", "RequestsModel", function(FlotrGraphHelper, RequestsModel) {
	 var currentColors = []; 
	  
	  var linkFn = function(scope, element, attrs) {
		  
		  console.log("graph entry");
		 	 
		  
		  function onSuccess(data) {
		    	 //var plot = $.plot("#graph_placeholder", FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget));
		    	//plot.setData(FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors));   		   	
		     //	plot.draw();	
		      element.height(265);
		      console.log(data);
		      Flotr.draw(element[0], FlotrGraphHelper.transformSeriesOfDatapoints(data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, 0.7));
		    }     

	    function update() {     
	    	return RequestsModel.getData("demo").success(onSuccess);
	    }

	    function calculateWidth(size_x) {
	      var widthMapping = { 1: 290, 2: 630, 3: 965 };
	      return widthMapping[size_x];
	    }

	    scope.init(update);
	   
	    scope.$watch("config.size_x", function(newValue, oldValue) {
	      if (newValue !== oldValue) {
	        element.width(calculateWidth(3));
	        scope.init(update);
	      }

	    });

	  };

	  return {
	    //template: '<div class="graph-container"><div id="graph_placeholder"  style=" height:300px; width:700px"></div></div>',   
		  template: '<div class="graph_container"></div>',
	    link: linkFn
	  };
	}]);








