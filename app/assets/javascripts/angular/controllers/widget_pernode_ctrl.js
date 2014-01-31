app.controller("WidgetPerNodeCtrl", [ "$scope", "UpdateWidget", "Sources", "MetricsHelper",	function($scope, UpdateWidget, Sources, MetricsHelper) {

			metrics = [];
			$scope.metrics = [{value : 'cpu'}, {value : 'http requests'	} ];
			$scope.sources = Sources.availableSources($scope.widget.kind);			
			$scope.update_widget_range = function(updatetime, widget) {
				widget.range = updatetime;
				widget.$update;
				UpdateWidget.prepForBroadcast(widget);
			};

			$scope.update_widget_source = function(updatesource, widget) {
				widget.source = updatesource;
				widget.$update;
				UpdateWidget.prepForBroadcast(widget);
			};

			$scope.update_widget_metrics = function(updatetarget, widget) {								
				widget.targets = MetricsHelper.getTarget(updatetarget);
				widget.$update;				
				UpdateWidget.prepForBroadcast(widget);
			};

			$scope.$on('handleBroadcast', function() {
				$scope.message = UpdateWidget.message;
				$scope.button = UpdateWidget.sm;				
			});

		} ]);