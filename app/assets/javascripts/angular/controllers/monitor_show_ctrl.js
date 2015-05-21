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
app.controller("MonitorShowCtrl", ["$scope", "$rootScope", "$routeParams", "$location", "$timeout", "$window", "Widget", "UpdateWidget", "Sources",
function($scope, $rootScope, $routeParams, $location, $timeout, $window, Widget, UpdateWidget, Sources) {

	$scope.bookwidget = "widgetpernode";
	$rootScope.resolved = false;
	$scope.dashboard_id = $routeParams.id;

	$scope.widgets = Widget.query({
		dashboard_id : 1
	}, function() {
		$rootScope.resolved = true;
	});

	$scope.$on('handleBroadcast', function() {
		$scope.widget = UpdateWidget.message;
		replaceWidget($scope.widget.id, $scope.widget);
		$scope.sm = UpdateWidget.sm;
	});

	$scope.c_launch_namegen = $routeParams.book;

	function replaceWidget(id, widget) {
		var w = _.findWhere($scope.widgets, {
			id : widget.id
		});
		_.extend(w, widget);
	}

	function bookMapping(book) {
		return {
			value : book
		};
	}

	$scope.sm_view = function() {
		UpdateWidget.showForBroadcast(false);
	}
	if ($routeParams.book != null) {
		$scope.widgetpernode = "widgetpernode";
		$scope.templateUrl = "angular/templates/widget/book_show.html.erb";
	}

}]);
