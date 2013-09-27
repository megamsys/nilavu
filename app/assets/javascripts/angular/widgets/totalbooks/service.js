app.factory("TotalBooksModel", ["$http", "TimeSelector", function($http, TimeSelector) {

	function getParams(config, source) {
	    return {	
	    	 from: TimeSelector.getFrom("60-minutes"),
	         to: TimeSelector.getCurrent("60-minutes"),
	      kind: 'totalbooks',
	      name: source,
	      wid: config.id
	    };
	  }	 

  function getData(config, source) {
	  console.log("data source entry--->"+source);	
	return $http.get("/api/data_sources/totalbooks.json", { params: getParams(config, source) });
  }
  return {
    getData: getData
  };
  
}]);