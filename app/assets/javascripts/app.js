/* We  do  a manual load of angular. Don't add ng-app in the html tag, this will result in booting it twice.
** the order where angular gets loaded in application.js should be kept, as it will not load when the require is move
** down the order
*/
jQuery(document).ready(function() {
	angular.bootstrap(document, [ 'Nilavu' ]);
});

var app = angular.module('Nilavu', [ 'ngResource', 'ui.router', 'ui.state' ]);

app.config(function($routeProvider, $locationProvider) {
	$locationProvider.html5Mode(true);
	console.log("route provider");
	$routeProvider.when("/dashboards/:id", {
		template : JST['angular/templates/dashboards/show'],
		controller : "DashboardShowCtrl"
	}).otherwise({
		redirectTo : "/dashboards/:id"
	});
});

// template: JST['angular/templates/dashboards/show']

/*
 * app.config(['$routeProvider', '$stateProvider', '$urlRouterProvider',
 * function($routeProvider, $stateProvider, $urlRouterProvider) {
 * console.log("provider"); $stateProvider .state('show', { url:
 * 'dashboards/:id', template: 'angular/templates/dashboards/show.html.erb',
 * controller: 'DashboardShowCtrl' }); }]);
 */