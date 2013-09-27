app.factory("GraphModel", ["$http", "TimeSelector", "Sources", function($http, TimeSelector, Sources) {

	function getParams(config, book) {
	    return {	
	    	widgetid: config.id,
	    	 from: TimeSelector.getFrom(config.range),
	         to: TimeSelector.getCurrent(config.range),
	      kind: config.kind,
	      name: config.source,
	      host: book,
	      target: config.targets
	    };
	  }	 

  function getData(config, book) {		  
	  console.log("data source entry----->"+config);	
	return $http.get("/api/data_sources/datapoints.json", { params: getParams(config, book) });
  }
  return {
    getData: getData
  };
  
}]);