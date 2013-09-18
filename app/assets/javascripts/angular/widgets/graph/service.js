app.factory("GraphModel", ["$http", "TimeSelector", "Sources", function($http, TimeSelector, Sources) {

	function getParams(config) {
	    return {	
	    	 from: TimeSelector.getFrom(config.settings),
	         to: TimeSelector.getCurrent(config.settings),
	      kind: config.kind,
	      name: config.source
	    };
	  }	 

  function getData(config) {
	  console.log("data source entry----->"+config);	
	return $http.get("/api/data_sources/datapoints.json", { params: getParams(config) });
  }
  return {
    getData: getData
  };
  
}]);