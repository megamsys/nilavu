app.factory("FlotrGraphHelper", ["ColorFactory", "SuffixFormatter", "$window",
function(ColorFactory, SuffixFormatter, $window) {

   // TODO: refactor
  function timeUnit(range, size) {
    switch(range) {
    case "30-minutes":
    case "60-minutes":
    case "4hr":
    case "1-hours":
    case "hour":
    case "2hr":
    case "day":
    case "week":
    case "month":
      return "%H:%M";
    case "3-days":
      if (size === 1) {
        return "%m-%d";
      } else {
        return "%m-%d %H:%M";
      }
      break;
    case "7-days":
    case "this-week":
    case "previous-week":
    case "4-weeks":
    case "this-month":
    case "previous-month":
      return "%m-%d";
    case "this-year":
    case "previous-year":
      return "%m-%y";
    default:
      throw "unknown rangeString: " + range;
    }
  }

	function suffixFormatter(val, axis) {
		return SuffixFormatter.format(val, axis.tickDecimals);
	}

	function formatDate(date) {
		return $window.moment.utc(new Date(date)).local().format("YYYY-MM-DD HH:mm");
	}

	function trackFormatterFn(obj) {
		var data = {
			date : formatDate(obj.x * 1000),
			color : obj.series.color,
			label : obj.series.label,
			value : parseInt(obj.y, 10)
		};

		var html = '<span class="detail_swatch" style="background-color: {{color}}"></span>' + '{{label}}:{{value}}<br>' + '<span class="date">{{date}}</span>';

		return _.template(html, data);
	}

	function getYvalue(target) {
		switch(target) {
		case "pkts_out":
			return 10;
		case "pkts_in":
			return 8;
		case "bytes_in":
			return 15000;
		case "bytes_out":
			return 5000000;
		case "graph":
			return 6;
		case "cpu_system":
			return 100;
		case "cpu_idle":
			return 100;
		case "cpu_user":
			return 100;
		case "nginx_requests":
			return 800;
		case "load_five":
			return 1;
		case "proc_run":
			return 5;
		case "mem_cached":
			return 5000000;
		case "mem_free":
			return 200000;
		case "disk_free":
			return 20;
		case "disk_total":
			return 20;
		default:
			throw "unknown Target(METRIC NAME) : " + target;
		}
	}

	function defaultOptions(model, target) {
		return {
			series : {
				lines : {
					show : true,
					lineWidth : 2,
					fill : true,
					fillColor : {
						colors : [{
							opacity : 0.05
						}, {
							opacity : 0.01
						}]
					}
				},
				points : {
					show : true
				},
				shadowSize : 1
			},
			grid : {
				hoverable : true,
				clickable : true,
				tickColor : "#eee",
				borderWidth : {
					top : 0,
					right : 0,
					bottom : 1,
					left : 1
				},
				borderColor : {
					bottom : "#e5e6ef",
					left : "#e5e6ef"
				}
			},
			colors : ["#3cc051", "#6DABE5", "#52e136"],
			xaxis : {
				ticks : 5,
				tickDecimals : 0,
				tickLength : 0,
				mode: "time", 
				timeMode: "local", 
				timeUnit: 'second', 
				timeFormat: timeUnit("60-minutes", parseInt(1, 10))
			},
			yaxis : {
				ticks : 5,
				tickDecimals : 0,
				tickLength : 0,
				tickFormatter: suffixFormatter,
				max: getYvalue(target) || null
				
			}
		};
	}

	// reuse the same color for the same target
	function initColor(currentColors, index) {
		var color = null;
		if (!currentColors[index]) {
			color = ColorFactory.get();
			currentColors.push(color);
		} else {
			color = currentColors[index];
		}
		return color;
	}

	// swap x/y values since backend and flotr2 define it different
	function swapDatapoints(datapoints) {
		return _.map(datapoints, function(dp) {
			return [dp[1], dp[0]];
		});
	}

	function linesType(graph_type) {
		switch(graph_type) {
		case "area":
			return true;
		case "stacked":
			return true;
		case "line":
			return false;
		default:
			return false;
		}
	}

	function transformSeriesOfDatapoints(series, widget, currentColors) {

		return _.map(series, function(model, index) {
			return {
				color : initColor(currentColors, index),
				//color: '#E01B5D',
				lines : {
					fill : linesType("area"),
					lineWidth : 1
				},
				label : model.target,
				data : swapDatapoints(model.datapoints)
			};
		});
	}

	return {
		defaultOptions : defaultOptions,
		transformSeriesOfDatapoints : transformSeriesOfDatapoints
	};
}]);
