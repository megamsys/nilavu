app.factory("Dashboard", ["$resource", function($resource) {
  return $resource("/api/dashboards/:id.json", { id: "@id" },
  {
    'create':  { method: 'POST' },
    'index':   { method: 'GET', isArray: false },
    'show':    { method: 'GET', isArray: false },
    'update':  { method: 'PUT' },
    'destroy': { method: 'DELETE' }
  });
}]);