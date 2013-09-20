app.factory("Widget", ["$resource", function($resource) {
	console.log("id entry");
  return $resource("/api/dashboards/:dashboard_id/widgets/:id.json", { id: "@id", dashboard_id: 1 },
    {
      'create':  { method: 'POST' },
      'index':   { method: 'GET', isArray: true },
      'show':    { method: 'GET', isArray: false },
      'update':  { method: 'PUT' },
      'destroy': { method: 'DELETE' }
    }
  ); 
  
}]);