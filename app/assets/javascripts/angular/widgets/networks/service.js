app.factory("NetworksModel", ["$http", "TimeSelector", "Sources", function($http, TimeSelector, Sources) {

	function getParams(config) {
		//alert(config.targets);
	    return {	
	    	widgetid: config.id,
	    	 //from: TimeSelector.getFrom(config.range),
	         //to: TimeSelector.getCurrent(config.range),
	    	range: config.range,
	      kind: config.kind,
	      name: config.source,	      
	      target: config.targets
	    };
	  }	 

  function getData(config) {		  
	  console.log("data source entry----->"+config);	
	return $http.get("/api/data_sources/networks_datapoints.json", { params: getParams(config) });
  }
  return {
    getData: getData
  };
  
}]);