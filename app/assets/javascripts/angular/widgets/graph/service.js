app.factory("GraphModel", ["$http", "TimeSelector", "Sources", function($http, TimeSelector, Sources) {

	function getParams(config) {
	    return {	
	    	widgetid: config.id,
	    	 from: TimeSelector.getFrom(config.range),
	         to: TimeSelector.getCurrent(config.range),
	    	range: config.range,
	      kind: config.kind,
	      name: config.source,	      
	      target: config.targets
	    };
	  }	 

  function getData(config) {		  
	  console.log("data source entry----->"+config);	
	  console.log("TEST!-----------> 33333");

	return $http.get("/api/data_sources/datapoints.json", { params: getParams(config) });
  }
  return {
    getData: getData
  };
  
}]);