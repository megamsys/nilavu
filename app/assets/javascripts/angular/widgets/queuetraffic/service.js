app.factory("QueueTrafficModel", ["$http", "TimeSelector", function($http, TimeSelector) {

	function getParams(source) {
	    return {	
	    	 from: TimeSelector.getFrom("60-minutes"),
	         to: TimeSelector.getCurrent("60-minutes"),
	      kind: 'queuetraffic',
	      name: source
	    };
	  }	 

  function getData(source) {
	  console.log("data source entry--->"+source);	
	return $http.get("/api/data_sources/queuetraffic.json", { params: getParams(source) });
  }
  return {
    getData: getData
  };
  
}]);