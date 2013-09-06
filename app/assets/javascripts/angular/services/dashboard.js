app.factory("Dashboard", ["$resource", function($resource) {
  return $resource("/dashboards/:id", { id: "@id" },
  {    	
    'show':    { method: 'GET', isArray: false }
     });
}]);