var Monitoring = React.createClass({

  getInitialState: function getInitialState() {
    console.log("=======================");
//    this.setUpgoogcharts();

   console.log("=====");
    return {
      JsonData: [],
    };
  },

  componentDidMount: function() {
    setInterval(this.updateData, 1000);
    this.drawCharts();

  },
  componentDidUpdate: function(){
    this.drawCharts();
  },

  drawCharts: function(){
    var stats = this.state.JsonData;
    console.log("booyah");
    console.log(stats);
    console.log("booyah");
    var options = {
      title: 'megam',
      'width':400,
      'height':300
    };

    //if (stats.spec.has_cpu && !hasResource(stats, "cpu")) {
  //    return;
  //  }

    var titles = ["Time", "Total"];
    var data = [];
    console.log(data.length);
    for (var i = 1; i < stats.length; i++) {
      var cur = stats[i];
      var prev = stats[i - 1];
      var intervalInNs = this.getInterval(cur.timestamp, prev.timestamp);

      var elements = [];
      elements.push(cur.timestamp);
      elements.push((cur.cpu.usage.total - prev.cpu.usage.total) / intervalInNs);
      data.push(elements);
    }


//=====================================titles, data, elementId, unit

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

dataTable.addColumn('datetime', titles[0]);
for (var i = 1; i < titles.length; i++) {
  dataTable.addColumn('number', titles[i]);
}
dataTable.addRows(data);

// TODO(vmarmol): Look into changing the view window to get a smoother animation.
var opts = {
  curveType : 'function',
  height : 300,
  legend : {
    position : "none"
  },
  focusTarget : "category",
  vAxis : {
    title : "Cores",
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

var chart = new google.visualization.LineChart(document.getElementById("chart-ct"));

chart.draw(dataTable, opts);
},

getInterval: function(current, previous) {
 var cur = new Date(current);
 var prev = new Date(previous);

 // ms -> ns.
 return (cur.getTime() - prev.getTime()) * 1000000;
},
  /*  var chart = new this.props.google.visualization.LineChart(
      document.getElementById("chart-ct")
    );
    chart.draw(data, options);
},
    */


  updateData: function() {

    $.get(this.props.host, function(data) {
      console.log("gotut");
     var JsonData = this.state.JsonData
      JsonData.push(data)
      this.setState({
       JsonData: JsonData
      })
    }.bind(this));

console.log(this.state.JsonData);

  },

  render: function() {
        return React.DOM.div({id: "chart-ct", style: {height: "500px"}});
  }
});
