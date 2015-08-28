/*
 ** Copyright [2013-2015] [Megam Systems]
 **
 ** Licensed under the Apache License, Version 2.0 (the "License");
 ** you may not use this file except in compliance with the License.
 ** You may obtain a copy of the License at
 **
 ** http://www.apache.org/licenses/LICENSE-2.0
 **
 ** Unless required by applicable law or agreed to in writing, software
 ** distributed under the License is distributed on an "AS IS" BASIS,
 ** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ** See the License for the specific language governing permissions and
 ** limitations under the License.
 */
var app = angular.module('Nilavu', ["ngResource", "ngSanitize", "ngRoute"]);

app.config(["$routeProvider", "$locationProvider",
function($routeProvider, $locationProvider) {
	$locationProvider.html5Mode(true);
	$routeProvider.when("/", {
		templateUrl : 'angular/templates/monitor/show.html.erb',
		controller : "MonitorShowCtrl"
	}).when("/runtime", {
		templateUrl : 'angular/templates/monitor/show.html.erb',
		controller : "MonitorShowCtrl"
	}).when("/oneapps", {
		templateUrl : 'angular/templates/monitor/show.html.erb',
		controller : "MonitorShowCtrl"
	}).when("/monitor/:id/:book", {
		templateUrl : 'angular/templates/monitor/show.html.erb',
		controller : "MonitorShowCtrl"
	});
}]);

app.config(["$httpProvider",
function($httpProvider) {
	$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');

	$httpProvider.defaults.headers.common['Accept'] = "application/json";
	$httpProvider.defaults.headers['common']['X-Requested-With'] = 'XMLHttpRequest';
}]);

// use angular/mustache style {{variable}} interpolation
_.templateSettings = {
	interpolate : /\{\{(.+?)\}\}/g
};

function BookCtrl($scope, $routeParams) {
	$scope.templateUrl = "angular/templates/widget/book_show.html.erb";
}
