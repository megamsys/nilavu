var app = angular.module('Nilavu', ['ngResource']);

app.config(function($routeProvider, $locationProvider) {
	  $locationProvider.html5Mode(true);
	  $routeProvider
	    .when("/dashboards", { template: JST["angular/templates/dashboards/index"], controller: "DashboardIndexCtrl" })
	    .when("/dashboards/:id", { template: JST["angular/templates/dashboards/show"], controller: "DashboardShowCtrl" });
	   //.when('/cloud_books', { controller: 'cloudbooksctrl'});
	    //.when("/cloud_books", {template: ".../views/cloud_books/index.html", controller: ".../controllers/CloudBooksController" });	  
	    //.otherwise({ redirectTo: "/" });
	});


	app.config(function($httpProvider) {
	  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	});	

	// use angular/mustache style {{variable}} interpolation
	_.templateSettings = {
	  interpolate : /\{\{(.+?)\}\}/g
	};

/*
	function cloudbooksctrl($scope, $location){
	    $apply(function() { 
	        $location.path("/cloud_books/index"); 
	    });
	}
*/