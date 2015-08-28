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
app.directive("graph", ["FlotrGraphHelper", "GraphModel", "$routeParams", "Sources",
function(FlotrGraphHelper, GraphModel, $routeParams, Sources) {

	var currentColors = [];

	var linkFn = function(scope, element, attrs) {

		function onSuccess(data) {
			console.log("TEST!-----------> 1111");
			console.log($.AppName);
			scope.host = data.host;
			scope.uptime = data.uptime;
			scope.os = data.os;
			scope.cpus = data.cpus;		
			cpu_system_data = data.cpu;			
		    var plot = $.plot($("#cpu_system_graph"), FlotrGraphHelper.transformSeriesOfDatapoints(cpu_system_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "cpu_system"));

			var previousPoint = null;
			$("#cpu_system_graph").bind("plothover", function(event, pos, item) {
				$("#x").text(pos.x.toFixed(2));
				$("#y").text(pos.y.toFixed(2));

				if (item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;

						$("#tooltip").remove();
						var x = item.datapoint[0].toFixed(2), y = item.datapoint[1].toFixed(2);

						showTooltip(item.pageX, item.pageY, item.series.label + " of " + x + " = " + y);
					}
				} else {
					$("#tooltip").remove();
					previousPoint = null;
				}
			});	
		
			disk_data = data.disk;			
			var plot = $.plot($("#disk_free_graph"), FlotrGraphHelper.transformSeriesOfDatapoints(disk_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "disk_free"));

			var previousPoint = null;
			$("#disk_free_graph").bind("plothover", function(event, pos, item) {
				$("#x").text(pos.x.toFixed(2));
				$("#y").text(pos.y.toFixed(2));

				if (item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;

						$("#tooltip").remove();
						var x = item.datapoint[0].toFixed(2), y = item.datapoint[1].toFixed(2);

						showTooltip(item.pageX, item.pageY, item.series.label + " of " + x + " = " + y);
					}
				} else {
					$("#tooltip").remove();
					previousPoint = null;
				}
			});

			mem_free_data = data.memory;			
			var plot = $.plot($("#mem_free_graph"), FlotrGraphHelper.transformSeriesOfDatapoints(mem_free_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "mem_free"));

			var previousPoint = null;
			$("#mem_free_graph").bind("plothover", function(event, pos, item) {
				$("#x").text(pos.x.toFixed(2));
				$("#y").text(pos.y.toFixed(2));

				if (item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;

						$("#tooltip").remove();
						var x = item.datapoint[0].toFixed(2), y = item.datapoint[1].toFixed(2);

						showTooltip(item.pageX, item.pageY, item.series.label + " of " + x + " = " + y);
					}
				} else {
					$("#tooltip").remove();
					previousPoint = null;
				}
			});

			nginx_requests_data = data.network;			
			var plot = $.plot($("#nginx_requests_graph"), FlotrGraphHelper.transformSeriesOfDatapoints(nginx_requests_data, scope.widget, currentColors), FlotrGraphHelper.defaultOptions(scope.widget, "nginx_requests"));

			var previousPoint = null;
			$("#nginx_requests_graph").bind("plothover", function(event, pos, item) {
				$("#x").text(pos.x.toFixed(2));
				$("#y").text(pos.y.toFixed(2));

				if (item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;

						$("#tooltip").remove();
						var x = item.datapoint[0].toFixed(2), y = item.datapoint[1].toFixed(2);

						showTooltip(item.pageX, item.pageY, item.series.label + " of " + x + " = " + y);
					}
				} else {
					$("#tooltip").remove();
					previousPoint = null;
				}
			});			
		}

		function gett(name) {
			return "scope.graph_targets[0].cpu_system";
		}

		function randValue() {
			return (Math.floor(Math.random() * (1 + 40 - 20))) + 20;
		}

		function showTooltip(x, y, contents) {
			$('<div id="tooltip">' + contents + '</div>').css({
				position : 'absolute',
				display : 'none',
				top : y + 5,
				left : x + 15,
				border : '1px solid #333',
				padding : '4px',
				color : '#fff',
				'border-radius' : '3px',
				'background-color' : '#333',
				opacity : 0.80
			}).appendTo("body").fadeIn(200);
		}

		function update() {			
			scope.widgets.targets = "cpu_system";
			return GraphModel.getData(scope.widget, $.AppName).success(onSuccess);
			//}
		}

		function calculateWidth(size_x) {
			var widthMapping = {
				1 : 290,
				2 : 630,
				3 : 965
			};
			return widthMapping[size_x];
		}


		scope.init(update);

		scope.$watch("config.size_x", function(newValue, oldValue) {
			if (newValue !== oldValue) {
				element.width(calculateWidth(2));
				scope.init(update);
			}

		});

	};

	return {
		templateUrl : 'angular/templates/widgets/pernode/show.html.erb',
		controller : "WidgetPerNodeCtrl",
		link : linkFn
	};
}]);
