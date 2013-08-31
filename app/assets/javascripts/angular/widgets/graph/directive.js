app.directive("graph", function() {
	console.log("dir entry");
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
});