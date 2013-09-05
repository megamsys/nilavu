app.factory("Widget", ["$resource", function($resource) {
	console.log("id entry");
  return $resource("/dashboards/:dashboard_id/widgets/:id", { id: "@id", dashboard_id: 1 },
    {
      'create':  { method: 'POST' },
      'index':   { method: 'GET', isArray: true },
      'show':    { method: 'GET', isArray: false },
      'update':  { method: 'PUT' },
      'destroy': { method: 'DELETE' }
    }
  );
}]);