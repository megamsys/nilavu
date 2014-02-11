var app = angular.module('Nilavu', [ "ngResource", "ngSanitize", "ngRoute",
		"ngAnimate", 'cgBusy', 'ajoslin.promise-tracker' ]);

app.config([ "$routeProvider", "$locationProvider",
		function($routeProvider, $locationProvider) {
			$locationProvider.html5Mode(true);
			$routeProvider.when("/dashboards", {
				templateUrl : 'angular/templates/dashboards/index.html.erb',
				controller : "DashboardIndexCtrl"
			}).when("/dashboards/:id", {
				templateUrl : 'angular/templates/dashboards/show.html.erb',
				controller : "DashboardShowCtrl"
			}).when("/dashboards/:id/:book", {
				templateUrl : 'angular/templates/dashboards/show.html.erb',
				controller : "DashboardShowCtrl"
			});
		} ]);


 
app.config(["$httpProvider",
				function($httpProvider) {
					$httpProvider.defaults.headers.common['X-CSRF-Token'] = $(
							'meta[name=csrf-token]').attr('content');

					$httpProvider.defaults.headers.common['Accept'] = "application/json";
					$httpProvider.defaults.headers['common']['X-Requested-With'] = 'XMLHttpRequest';
				} ]);

// use angular/mustache style {{variable}} interpolation
_.templateSettings = {
	interpolate : /\{\{(.+?)\}\}/g
};

function cloudbooksctrl($scope, $location) {
	console.log("cloudbookctrl: $location---->" + $location.path());
	$apply(function() {
		$location.path("/cloud_books/index").replace();
	});
}

function BookCtrl($scope, $routeParams) {
	// $scope.templateUrl = JST["angular/templates/widget/book_show"];
	$scope.templateUrl = "angular/templates/widget/book_show.html.erb";
}
