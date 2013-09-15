app.directive("newbooks", ["NewBooksModel", function(NewBooksModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return NewBooksModel.getData("usermodel").success(onSuccess);
		    }

		    scope.init(update);
		  };

  return {
	  template: '<div class="span4"><ul class="site-stats"><li><i class="icon-user"></i><strong>{{data}}</strong><small>New Books (last week)</small></li></ul></div>',    
      link: linkFn
  };
}]);








