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
		    $(".peity_bar_good span").peity("bar", {
				colour : "#459D1C"
			});	
		    scope.init(update);
		  };

  return {
	  template: '<li><div class="left peity_bar_good"><span>2,4,9,7,12,10,12</span>+{{average}}%</div><div class="right"><strong>{{data}}</strong>Apps Running</div></li>',    
      link: linkFn
  };
}]);

