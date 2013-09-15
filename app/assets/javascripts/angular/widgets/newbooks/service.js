app.factory("NewBooksModel", ["$http", "TimeSelector", function($http, TimeSelector) {

	function getParams(source) {
	    return {	
	    	 from: TimeSelector.getFrom("60-minutes"),
	         to: TimeSelector.getCurrent("60-minutes"),
	      kind: 'newbooks',
	      name: source
	    };
	  }	 

  function getData(source) {
	  console.log("data source entry--->"+source);	
	return $http.get("/api/data_sources/newbooks.json", { params: getParams(source) });
  }
  return {
    getData: getData
  };
  
}]);