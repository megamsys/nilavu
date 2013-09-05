app.directive("graph", function() {              
	 console.log("graph entry");
	 return{
	        restrict: 'E',
	        link: function(scope, elem, attrs){
	            
	            var chart = null,
	                opts  = { };
	            
	            var data = scope[attrs.ngModel];            
	            
	            scope.$watch('data', function(v){
	                if(!chart){
	                    chart = $.plot(elem, v , opts);
	                    elem.show();
	                }else{
	                    chart.setData(v);
	                    chart.setupGrid();
	                    chart.draw();
	                }
	            });
	        }
	    };
	 
	   /*var sin = [], cos = [];
	    for (var i = 0; i < 14; i += 0.5) {
	        sin.push([i, Math.sin(i)]);
	        cos.push([i, Math.cos(i)]);
	    }

		// === Make chart === //
	    var plot = $.plot($(".chart"),
	           [ { data: sin, label: "sin(x)", color: "#BA1E20"}, { data: cos, label: "cos(x)",color: "#459D1C" } ], {
	               series: {
	                   lines: { show: true },
	                   points: { show: true }
	               },
	               grid: { hoverable: true, clickable: true },
	               yaxis: { min: -1.6, max: 1.6 }
			   });*/
});