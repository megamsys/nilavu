app.directive("requestserved", ["RequestServedModel", function(RequestServedModel) {
	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return RequestServedModel.getData("demo").success(onSuccess);
		    }

		    scope.init(update);
		  };

return {
	  template: '<div class="col-xs-4 center"><ul  class="stat-boxes"><li><div class="left peity_bar_bad"><span>3,5,9,7,12,20,10</span>-50%</div><div class="right"><strong>{{data}}</strong>Requests Served(rpm)</div></li></ul></div>',    
      //template: '<i class="icon-user"></i><span>3,5,9,7,12,20,10</span>-50%<br/><strong>{{data}}</strong><small>Requests Served(rpm)</small>',
	  link: linkFn
};
}]);




