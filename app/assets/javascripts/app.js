var app = angular.module('Nilavu', ['ngResource', 'ui.router', 'ui.state']);

app.config(function($routeProvider, $locationProvider) {
	  $locationProvider.html5Mode(true);
	  console.log("route provider");
	  $routeProvider	    
	    .when("/dashboards/:id", { template: JST['angular/templates/dashboards/show'],  controller: "DashboardShowCtrl" })
	    .otherwise({ redirectTo: "/dashboards/:id" });
	});
// template: JST['angular/templates/dashboards/show']    

/*app.config(['$routeProvider', '$stateProvider', '$urlRouterProvider', function($routeProvider, $stateProvider, $urlRouterProvider) {  
    console.log("provider");
	$stateProvider
    .state('show', {
        url: 'dashboards/:id',
        template: 'angular/templates/dashboards/show.html.erb',           
        controller: 'DashboardShowCtrl'
    });
}]);*/