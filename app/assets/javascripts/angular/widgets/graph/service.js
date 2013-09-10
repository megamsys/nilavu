app.factory("GraphModel", ["$http", "TimeSelector", function($http, TimeSelector) {

	function getParams(source) {
	    return {	
	    	 from: TimeSelector.getFrom("60-minutes"),
	         to: TimeSelector.getCurrent("60-minutes"),
	      kind: 'datapoints',
	      name: source
	    };
	  }	 

  function getData(source) {
	  console.log("data source entry");	
	return $http.get("/api/data_sources.json", { params: getParams(source) });
  }
  return {
    getData: getData
  };
  
}]);