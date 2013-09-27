app.directive("runningbooks", ["RunningBooksModel", function(RunningBooksModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      scope.average = data.average;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return RunningBooksModel.getData(scope.widget,"usermodel").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="span4 center"><ul class="stat-boxes"><li><div class="left peity_bar_good"><span>2,4,9,7,12,10,12</span>+{{average}}%</div><div class="right"><strong>{{data}}</strong>Books Running</div></li></ul></div>',    
      link: linkFn
  };
}]);








