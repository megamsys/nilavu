var app = angular.module('Nilavu', []);

app.config(function($routeProvider, $locationProvider) {
	  $locationProvider.html5Mode(true);
	  $routeProvider
	    .when("/dashboards", { template: JST['templates/dashboards/index'], controller: "DashboardIndexCtrl" })	       
	    .otherwise({ redirectTo: "/dashboards" });
	});

