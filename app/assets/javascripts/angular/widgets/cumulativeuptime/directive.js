app.directive("cumulativeuptime", ["CumulativeUptimeModel", function(CumulativeUptimeModel) {

	 var linkFn = function(scope, element, attrs) {
		    // console.log(element.html(), attrs)

		   
		    function onSuccess(data) {
		      scope.data = data.value;
		      //scope.data.label = scope.data.label || scope.widget.label;		      
		    }

		    function update() {
		      return CumulativeUptimeModel.getData("demo").success(onSuccess);
		    }
		    
		    $(".peity_bar_neutral span").peity("bar", {
				colour : "#757575"
			});
		    scope.init(update);
		  };

  return {
	  template: '<li><div class="left peity_bar_neutral"><span>20,15,18,14,10,9,9,9</span>99.3%</div><div class="right"><strong>{{data}}</strong>Apps Uptime(days.hrs)</div></li>',              
      link: linkFn
  };
}]);








