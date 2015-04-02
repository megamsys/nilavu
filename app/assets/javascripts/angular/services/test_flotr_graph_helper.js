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
app.factory("TestFlotrGraphHelper", ["TestColorFactory", "SuffixFormatter", "$window", function(TestColorFactory, SuffixFormatter, $window) {
	  console.log("flotr graph entry");
  // TODO: refactor
  function timeUnit(range, size) {
    switch(range) {
    case "30-minutes":
    case "60-minutes":
    case "hour":	
    case "1-hours":
    case "12-hours":
    case "24-hours":
    case "today":
    case "yesterday":
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
      date: formatDate(obj.x * 1000),
      color: obj.series.color,
      label: obj.series.label,
      value: parseInt(obj.y, 10)
    };

    var html = '<span class="detail_swatch" style="background-color: {{color}}"></span>' +
               '{{label}}:{{value}}<br>' +
               '<span class="date">{{date}}</span>';

    return _.template(html, data);
  }
  //TODO_TOM
  function getYvalue(target) {
	    switch(target) {
	    case "pkts_out":
	      return 10;
	    case "pkts_in":
	      return 8;
	    case "bytes_in":
		      return 15000;
	    case "bytes_out":
		      return 14000;
	    case "graph":
		      return 6;
	    default:
	      throw "unknown Target(METRIC NAME) : " + target;
	    }
	  }
  
  
  function defaultOptions(model, target) {
	  return {
		  grid: {
				borderWidth: 1,
				minBorderMargin: 20,
				labelMargin: 10,
				backgroundColor: {
					colors: ["#fff", "#e4f4f4"]
				},
				margin: {
					top: 8,
					bottom: 20,
					left: 20
				},
				markings: function(axes) {
					var markings = [];
					var xaxis = axes.xaxis;
					for (var x = Math.floor(xaxis.min); x < xaxis.max; x += xaxis.tickSize * 2) {
						markings.push({ xaxis: { from: x, to: x + xaxis.tickSize }, color: "rgba(255, 0, 255, 0)" });
					}
					return markings;
				}
			},
			xaxis: {
				mode: "time", timeMode: "local", timeUnit: 'second', timeFormat: timeUnit("60-minutes", parseInt(1, 10))
			},
			yaxis: {
		        tickFormatter: suffixFormatter,
		        max: getYvalue(target) || null
		      },  
			legend: {
				show: true
			}
	  };
  }
  
  
  
 /* function defaultOptions(model, y_max) {
    return {    	
      shadowSize: 1,
      grid: {
        outline: "", verticalLines: false, horizontalLines: false, labelMargin: 10
      },
      xaxis: {
        mode: "time", timeMode: "local", timeUnit: 'minute', timeFormat: timeUnit("60-minutes", parseInt(1, 10))
      },
      yaxis: {
        tickFormatter: suffixFormatter,
        max: y_max || null
      },    
    };
  }*/

  // reuse the same color for the same target
  function initColor(currentColors, index) {
    var color = null;
    if (!currentColors[index]) {
      color = TestColorFactory.get();
      currentColors.push(color);
    } else {
      color = currentColors[index];
    }
    return color;
  }

  // swap x/y values since backend and flotr2 define it different
  function swapDatapoints(datapoints) {
    return _.map(datapoints[0], function(dp) {
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
        //color: initColor(currentColors, index),
    	//color: '#E01B5D',
        lines: { fill: linesType("area"), lineWidth: 1 },
        //label: model.target,
        data : swapDatapoints(model.datapoints)
      };
    });
  }

  return {
    defaultOptions: defaultOptions,
    transformSeriesOfDatapoints: transformSeriesOfDatapoints
  };
}]);
