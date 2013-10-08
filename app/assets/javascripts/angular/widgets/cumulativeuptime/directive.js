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
	  template: '<div class="span4 center"><ul class="stat-boxes"><li><div class="left peity_bar_neutral"><span>20,15,18,14,10,9,9,9</span>99.3%</div><div class="right"><strong>{{data}}</strong>Books Uptime(days.hrs)</div></li></ul></div>',              
      link: linkFn
  };
}]);








