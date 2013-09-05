app.factory("GraphWidgetService", ["$http", function($http) {

 
	function getParams(source) {
	    return {
	      kind: 'datapoints',
	      name: source
	    };
	  }
	
  function getData(source) {
	  console.log("data source entry");
	 b = [];
	 b = $http.get("api/data_sources.json", { params: getParams(source) });
	 console.log(b);
    return b;
  }
  return {
    getData: getData
  };
}]);