var app = angular.module('Nilavu', ['ngResource', 'ui.router', 'ui.state']);

app.config(function($routeProvider, $locationProvider) {
	  $locationProvider.html5Mode(true);
	  $routeProvider
	    .when("/dashboards", { template: JST["angular/templates/dashboards/index"], controller: "DashboardIndexCtrl" })
	    .when("/dashboards/:id", { template: JST["angular/templates/dashboards/show"], controller: "DashboardShowCtrl" });
	    //.when("/cloud_books", {template: ".../views/cloud_books/indes.html.erb"});	  
	    //.otherwise({ redirectTo: "/dashboards" });
	});


	app.config(function($httpProvider) {
	  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	});	

	// use angular/mustache style {{variable}} interpolation
	_.templateSettings = {
	  interpolate : /\{\{(.+?)\}\}/g
	};




/*app.config(function($routeProvider, $locationProvider) {
	  $locationProvider.html5Mode(true);
	  console.log("route provider");
	  $routeProvider	
	  .when("/dashboards", { template: 'angular/templates/dashboards/index.html', controller: "DashboardIndexCtrl" })
	  .when("/dashboards/:id", { template: 'angular/templates/dashboards/show.html',  
		                          controller: "DashboardShowCtrl" });
	    //.otherwise({ redirectTo: "/dashboards" });
	});

// template: JST['angular/templates/dashboards/show']   

//templateUrl:'dash_show.html', 

/*app.config(['$routeProvider', '$stateProvider', '$urlRouterProvider', function($routeProvider, $stateProvider, $urlRouterProvider) {  
    console.log("provider");
	$stateProvider
    .state('show', {
        url: 'dashboards/:id',
        template: 'angular/templates/dashboards/show.html.erb',           
        controller: 'DashboardShowCtrl'
    })
	.state('inde', {
        url: '/dashboards',
        template: 'angular/templates/dashboards/index.html.erb',           
        controller: 'DashboardShowCtrl'
    });
}]);*/


