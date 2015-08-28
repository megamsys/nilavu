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
app.controller("WidgetPerNodeCtrl", ["$scope", "UpdateWidget", "Sources", "MetricsHelper",
function($scope, UpdateWidget, Sources, MetricsHelper) {

	metrics = [];
	$scope.metrics = [{
		value : 'cpu'
	}, {
		value : 'http requests'
	}];
	
	$scope.sources = Sources.availableSources($scope.widget.kind);
	$scope.update_widget_range = function(updatetime, widget) {
		widget.range = updatetime;
		widget.$update
		UpdateWidget.prepForBroadcast(widget);
	};

	$scope.update_widget_source = function(updatesource, widget) {
		widget.source = updatesource;
		widget.$update
		UpdateWidget.prepForBroadcast(widget);
	};

	$scope.update_widget_metrics = function(updatetarget, widget) {
		widget.targets = MetricsHelper.getTarget(updatetarget);
		widget.$update
		UpdateWidget.prepForBroadcast(widget);
	};

	$scope.$on('handleBroadcast', function() {
		$scope.message = UpdateWidget.message;
		$scope.button = UpdateWidget.sm;
	});

}]); 