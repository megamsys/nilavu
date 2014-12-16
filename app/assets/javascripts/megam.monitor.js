var app = angular.module('Nilavu', ["ngResource", "ngSanitize", "ngRoute", 'angularSpinner']);

app.config(["$routeProvider", "$locationProvider",
function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider.when("/appruntime", {
        templateUrl : 'angular/templates/dashboards/show.html.erb',
        controller : "DashboardShowCtrl"
    }).when("/serviceruntime", {
        templateUrl : 'angular/templates/dashboards/show.html.erb',
        controller : "DashboardShowCtrl"
    }).when("/addonsruntime", {
        templateUrl : 'angular/templates/dashboards/show.html.erb',
        controller : "DashboardShowCtrl"
    }).when("/appruntime/:id", {
        templateUrl : 'angular/templates/dashboards/show.html.erb',
        controller : "DashboardShowCtrl"
    }).when("/dashboards/:id/:book", {
        templateUrl : 'angular/templates/dashboards/show.html.erb',
        controller : "DashboardShowCtrl"
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
