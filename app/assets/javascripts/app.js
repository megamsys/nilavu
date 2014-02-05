var app = angular.module('Nilavu', [ "ngResource", "ngSanitize", "ngRoute" ,"ngAnimate",'cgBusy','ajoslin.promise-tracker']);

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


angular.module('Nilavu').controller('DemoCtrl',function($scope,promiseTracker,$q,$timeout){

	$scope.delay1 = $scope.delay2 = 2000;

	$scope.demoBusy = function(trackerName,delay){

		//For the demo we're using a simple promise not $http since thats easier to control
		var testPromise = $q.defer();
		promiseTracker(trackerName).addPromise(testPromise.promise);
		$timeout(function(){
			testPromise.resolve();
		},delay);

	};

});

app
.config([
		"$httpProvider",
		function($httpProvider) {
			$httpProvider.defaults.headers.common['X-CSRF-Token'] = $(
					'meta[name=csrf-token]').attr('content');

			$httpProvider.defaults.headers.common['Accept'] = "application/json";
			$httpProvider.defaults.headers['common']['X-Requested-With'] = 'XMLHttpRequest';
		} ]);

//use angular/mustache style {{variable}} interpolation
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
	//$scope.templateUrl = JST["angular/templates/widget/book_show"];
	$scope.templateUrl = "angular/templates/widget/book_show.html.erb";
}

