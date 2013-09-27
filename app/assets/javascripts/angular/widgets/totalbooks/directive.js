app.directive("totalbooks", ["TotalBooksModel", function(TotalBooksModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return TotalBooksModel.getData(scope.widget, "usermodel").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="span4 center"><ul class="site-stats"><li><i class="icon-user"></i><strong>{{data}}</strong><small>Total Books</small></li></ul></div>',    
      link: linkFn
  };
}]);








