var app = angular.module('Nilavu', ['ngResource']);

app.config(function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true).hashPrefix('!');
	 // console.log($location.path());
	  $routeProvider
	    .when("/dashboards", { template: JST["angular/templates/dashboards/index"], controller: "DashboardIndexCtrl" })
	    .when("/dashboards/:id", { template: JST["angular/templates/dashboards/show"], controller: "DashboardShowCtrl" });
	   //.when('/cloud_books', { controller: 'MainCtrl'});
	    //.when("/cloud_books", {template: ".../views/cloud_books/index.html", controller: ".../controllers/CloudBooksController" });	  
	    //.otherwise({ redirectTo: $location.path() });
	});


	app.config(function($httpProvider) {
	  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	});	

	// use angular/mustache style {{variable}} interpolation
	_.templateSettings = {
	  interpolate : /\{\{(.+?)\}\}/g
	};	

	function cloudbooksctrl($scope, $location){
		console.log("$location---->"+$location.path());
	    $apply(function() { 
	        $location.path("/cloud_books/index").replace(); 
	    });
	}
