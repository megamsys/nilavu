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
app.directive("container", ["$routeParams", "ContainerModel", "Sources",
function($routeParams, ContainerModel, Sources) {

	var currentColors = [];

	var machineInfo = {
		"num_cores" : 8,
		"cpu_frequency_khz" : 2331000,
		"memory_capacity" : 12573564928,
		"machine_id" : "feab7d6287a98f3a620a096f5534fbff",
		"system_uuid" : "31DB7981-EACB-11DC-A452-0015176560B0",
		"boot_id" : "63e12cb5-feb9-4331-afe4-9cc421593f67",
		"filesystems" : [{
			"device" : "/dev/disk/by-uuid/0037a4db-e54e-4380-902a-87161b5897e7",
			"capacity" : 216511406080
		}, {
			"device" : "/dev/sdb1",
			"capacity" : 245998551040
		}],
		"disk_map" : {
			"8:0" : {
				"name" : "sda",
				"major" : 8,
				"minor" : 0,
				"size" : 250059350016,
				"scheduler" : "deadline"
			},
			"8:16" : {
				"name" : "sdb",
				"major" : 8,
				"minor" : 16,
				"size" : 250059350016,
				"scheduler" : "deadline"
			}
		},
		"network_devices" : [{
			"name" : "eth0",
			"mac_address" : "00:15:17:65:60:b0",
			"speed" : 1000,
			"mtu" : 1500
		}, {
			"name" : "eth1",
			"mac_address" : "00:15:17:65:60:b1",
			"speed" : 1000,
			"mtu" : 1500
		}, {
			"name" : "one",
			"mac_address" : "00:15:17:65:60:b0",
			"speed" : 0,
			"mtu" : 1500
		}, {
			"name" : "ovs-system",
			"mac_address" : "7a:8a:06:54:b3:d1",
			"speed" : 0,
			"mtu" : 1500
		}],
		"topology" : [{
			"node_id" : 0,
			"memory" : 12573564928,
			"cores" : [{
				"core_id" : 0,
				"thread_ids" : [0],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}, {
				"core_id" : 2,
				"thread_ids" : [1],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}, {
				"core_id" : 1,
				"thread_ids" : [4],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}, {
				"core_id" : 3,
				"thread_ids" : [5],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}],
			"caches" : null
		}, {
			"node_id" : 1,
			"memory" : 0,
			"cores" : [{
				"core_id" : 0,
				"thread_ids" : [2],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}, {
				"core_id" : 2,
				"thread_ids" : [3],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}, {
				"core_id" : 1,
				"thread_ids" : [6],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}, {
				"core_id" : 3,
				"thread_ids" : [7],
				"caches" : [{
					"size" : 32768,
					"type" : "Data",
					"level" : 1
				}, {
					"size" : 32768,
					"type" : "Instruction",
					"level" : 1
				}]
			}],
			"caches" : null
		}]
	};

	var linkFn = function(scope, element, attrs) {

		function onSuccess(data) {

			//var options = {
			//	title : 'Company Performance'
			//};
			//var chart = new google.visualization.LineChart(document.getElementById('chartdiv'));

			//chart.draw(data, options);
			console.log(data);
			drawCpuTotalUsage('cpu-total-usage-chart', machineInfo, data);
			drawCpuPerCoreUsage('cpu-per-core-usage-chart', machineInfo, data);
			drawCpuUsageBreakdown('cpu-usage-breakdown-chart', machineInfo, data);
		}

		function update() {
			scope.widgets.targets = "cpu_system";
			return ContainerModel.getData(scope.widget, $.AppName).success(onSuccess);
			//}
		}


		scope.init(update);

		scope.$watch("config.size_x", function(newValue, oldValue) {
			if (newValue !== oldValue) {
				element.width(calculateWidth(2));
				scope.init(update);
			}
		});

		// Draw the graph for CPU usage.
		function drawCpuTotalUsage(elementId, machineInfo, stats) {
			if (stats.spec.has_cpu && !hasResource(stats, "cpu")) {
				return;
			}

			var titles = ["Time", "Total"];
			var data = [];
			for (var i = 1; i < stats.stats.length; i++) {
				var cur = stats.stats[i];
				var prev = stats.stats[i - 1];
				var intervalInNs = getInterval(cur.timestamp, prev.timestamp);

				var elements = [];
				elements.push(cur.timestamp);
				elements.push((cur.cpu.usage.total - prev.cpu.usage.total) / intervalInNs);
				data.push(elements);
			}
			drawLineChart(titles, data, elementId, "Cores");
		}

		// Draw the graph for per-core CPU usage.
		function drawCpuPerCoreUsage(elementId, machineInfo, stats) {
			if (stats.spec.has_cpu && !hasResource(stats, "cpu")) {
				return;
			}

			// Add a title for each core.
			var titles = ["Time"];
			for (var i = 0; i < machineInfo.num_cores; i++) {
				titles.push("Core " + i);
			}
			var data = [];
			for (var i = 1; i < stats.stats.length; i++) {
				var cur = stats.stats[i];
				var prev = stats.stats[i - 1];
				var intervalInNs = getInterval(cur.timestamp, prev.timestamp);

				var elements = [];
				elements.push(cur.timestamp);
				for (var j = 0; j < machineInfo.num_cores; j++) {
					elements.push((cur.cpu.usage.per_cpu_usage[j] - prev.cpu.usage.per_cpu_usage[j]) / intervalInNs);
				}
				data.push(elements);
			}
			drawLineChart(titles, data, elementId, "Cores");
		}

		// Draw the graph for CPU usage breakdown.
		function drawCpuUsageBreakdown(elementId, machineInfo, containerInfo) {
			if (containerInfo.spec.has_cpu && !hasResource(containerInfo, "cpu")) {
				return;
			}

			var titles = ["Time", "User", "Kernel"];
			var data = [];
			for (var i = 1; i < containerInfo.stats.length; i++) {
				var cur = containerInfo.stats[i];
				var prev = containerInfo.stats[i - 1];
				var intervalInNs = getInterval(cur.timestamp, prev.timestamp);

				var elements = [];
				elements.push(cur.timestamp);
				elements.push((cur.cpu.usage.user - prev.cpu.usage.user) / intervalInNs);
				elements.push((cur.cpu.usage.system - prev.cpu.usage.system) / intervalInNs);
				data.push(elements);
			}
			drawLineChart(titles, data, elementId, "Cores");
		}

		// Draw a line chart.
		function drawLineChart(seriesTitles, data, elementId, unit) {
			var min = Infinity;
			var max = -Infinity;

			for (var i = 0; i < data.length; i++) {
				// Convert the first column to a Date.
				if (data[i] != null) {
					data[i][0] = new Date(data[i][0]);
				}

				// Find min, max.
				for (var j = 1; j < data[i].length; j++) {
					var val = data[i][j];
					if (val < min) {
						min = val;
					}
					if (val > max) {
						max = val;
					}
				}
			}

			// We don't want to show any values less than 0 so cap the min value at that.
			// At the same time, show 10% of the graph below the min value if we can.
			var minWindow = min - (max - min) / 10;
			if (minWindow < 0) {
				minWindow = 0;
			}

			// Add the definition of each column and the necessary data.
			var dataTable = new google.visualization.DataTable();

			dataTable.addColumn('datetime', seriesTitles[0]);
			for (var i = 1; i < seriesTitles.length; i++) {
				dataTable.addColumn('number', seriesTitles[i]);
			}
			dataTable.addRows(data);
			
			// Create and draw the visualization.
			//if (!( elementId in window.charts)) {
			//	window.charts[elementId] = new google.visualization.LineChart(document.getElementById(elementId));
			//}

			// TODO(vmarmol): Look into changing the view window to get a smoother animation.
			var opts = {
				curveType : 'function',
				height : 300,
				legend : {
					position : "none"
				},
				focusTarget : "category",
				vAxis : {
					title : unit,
					viewWindow : {
						min : minWindow,
					},
				},
				legend : {
					position : 'bottom',
				},
			};
			// If the whole data series has the same value, try to center it in the chart.
			if (min == max) {
				opts.vAxis.viewWindow.max = 1.1 * max;
				opts.vAxis.viewWindow.min = 0.9 * max;
			}
			
			var chart = new google.visualization.LineChart(document.getElementById(elementId));

			chart.draw(dataTable, opts);

			//window.charts[elementId].draw(dataTable, opts);
		}

		// Checks if the specified stats include the specified resource.
		function hasResource(stats, resource) {
			return stats.stats.length > 0 && stats.stats[0][resource];
		}

		// Gets the length of the interval in nanoseconds.
		function getInterval(current, previous) {
			var cur = new Date(current);
			var prev = new Date(previous);

			// ms -> ns.
			return (cur.getTime() - prev.getTime()) * 1000000;
		}

	};

	return {
		templateUrl : 'angular/templates/widgets/percontainer/show.html.erb',
		controller : "WidgetPerNodeCtrl",
		link : linkFn
	};
}]);

