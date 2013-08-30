app.factory("GraphModel", ["$http", "TimeSelector", function($http, TimeSelector) {

  function getParams() {
    return {
      from: TimeSelector.getFrom(10),
      to: TimeSelector.getCurrent(15),
      source: "demo",
      widget_id: 1
    };
  }

  function getData() {
    return $http.get("/api/data_sources/datapoints", { params: getParams() });
  }

  return {
    getData: getData
  };
}]);