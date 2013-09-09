app.factory("GraphModel", ["$http", function($http, $q) {

	function getParams(source) {
	    return {
	      kind: 'datapoints',
	      name: source
	    };
	  }
	 function onSuccess(data) {
	   return data
	    }

  function getData(source) {
	  console.log("data source entry");
	
	return $http.get("/api/data_sources.json", { params: getParams(source) });
	
	// console.log("success---->"+b);
	 
    //return b;
  }
  return {
    getData: getData
  };
  
}]);