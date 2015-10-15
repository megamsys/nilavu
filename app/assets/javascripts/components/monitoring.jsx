
var Cpu_total = React.createClass({

  getInitialState: function getInitialState() {
// this.setUpgoogcharts();
    return {
      JsonD: ''
    };
  },

  componentDidMount: function() {
    this.drawCharts();

    //setInterval(this.updateData, 2000);
//this.updateData();

  },
  componentDidUpdate: function() {

    this.drawCharts();
  },

  updateData: function() {

    $.get(this.props.host, function(data) {
      this.setState({
        JsonD: data
      })
    }.bind(this));

  },

  drawCharts: function() {
    var stats = this.state.JsonD;

//    if (stats.spec.has_cpu && !this.hasResource(stats, "cpu")) {
//      return;
//    }

    var titles = [
      "Time", "Total"
    ];
    var data = [];
    for (var i = 1; i < stats.stats; i++) {

      var cur = stats.stats[i];
      var prev = stats.stats[i - 1];
      var intervalInNs = this.getInterval(cur.timestamp, prev.timestamp);

      var elements = [];
      elements.push(cur.timestamp);
      elements.push((cur.cpu.usage.total - prev.cpu.usage.total) / intervalInNs);
      data.push(elements);
    }

    var min = Infinity;
    var max = -Infinity;

    for (var i = 0; i < data.length; i++) {
      if (data[i] != null) {
        data[i][0] = new Date(data[i][0]);
      }

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

    var minWindow = min - (max - min) / 15;
    if (minWindow < 0) {
      minWindow = 0;
    }

    var dataTable = new google.visualization.DataTable();

    dataTable.addColumn('datetime', titles[0]);
    for (var i = 1; i < titles.length; i++) {
      dataTable.addColumn('number', titles[i]);
    }
    dataTable.addRows(data);

    var opts = {
      curveType: 'function',
      height: 300,
      legend: {
        position: "none"
      },
      focusTarget: "category",
      vAxis: {
        title: "Cores",
        viewWindow: {
          min: minWindow
        }
      },
      legend: {
        position: 'bottom'
      }
    };
    if (min == max) {
      opts.vAxis.viewWindow.max = 3.1 * max;
      opts.vAxis.viewWindow.min = 0.9 * max;
    }

    var chart = new google.visualization.LineChart(document.getElementById("chart_1"));
  //  var chart2 = new google.visualization.LineChart(document.getElementById("chart_2"));

    chart.draw(dataTable, opts);
  //  chart2.draw(dataTable, opts);

  },

  hasResource: function(stats, resource) {
    return stats.stats.length > 0 && stats.stats[0][resource];
  },

  getInterval: function(current, previous) {
    var cur = new Date(current);
    var prev = new Date(previous);

    return (cur.getTime() - prev.getTime()) * 1000000;
  },

  render: function() {
    return (
      <div>
        <div id="chart_1"></div>
      </div>

    );
  }
});


/*var memory = React.createClass({

  getInitialState: function getInitialState() {
    this.drawCharts();

    return {
      JsonD: '',
      machineInfo: ''
    };
  },
  componentDidMount: function() {
    console.log("INSIDE????????????????????");
    console.log(this.props.host);
    setInterval(this.updateData, 1000);
    this.drawCharts();
  },
  componentDidUpdate: function() {

    this.drawCharts();
  },

  updateData: function() {
    $.get(this.props.host, function(data) {
      console.log(data);
      console.log("======123123123123123======");
      this.setState({
        JsonD: data
      })
    }.bind(this));

    $.get(this.props.mhost, function(mdata) {
      console.log(mdata);
      this.setState({
        machineInfo: mdata
      })
    }.bind(this));

  },

  drawCharts: function() {
    var stats = this.state.JsonD;

    var options = {
      title: 'megam',
      'width': 400,
      'height': 300
    };
    var titles = [
      "Time", "Total", "Hot"
    ];
    var data = [];

    for (var i = 1; i < stats.stats.length; i++) {
      var cur = stats.stats[i];
      var oneMegabyte = 1024 * 1024;
      var oneGigabyte = 1024 * oneMegabyte;
      var elements = [];
      elements.push(cur.timestamp);

      elements.push(cur.memory.usage / oneMegabyte);
      elements.push(cur.memory.working_set / oneMegabyte);
      data.push(elements);
    }

    var memory_limit = this.state.machineInfo.memory_capacity;
    if (stats.spec.memory.limit && (stats.spec.memory.limit < memory_limit)) {
      memory_limit = stats.spec.memory.limit;
    }
//var memory_limit = 1000000;

    var min = Infinity;
    var max = -Infinity;

    for (var i = 0; i < data.length; i++) {
      if (data[i] != null) {
        data[i][0] = new Date(data[i][0]);
      }

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

    var minWindow = min - (max - min) / 10;
    if (minWindow < 0) {
      minWindow = 0;
    }

    var dataTable = new google.visualization.DataTable();

    dataTable.addColumn('datetime', titles[0]);
    for (var i = 1; i < titles.length; i++) {
      dataTable.addColumn('number', titles[i]);
    }
    dataTable.addRows(data);

    var opts = {
      curveType: 'function',
      height: 300,
      legend: {
        position: "none"
      },
      focusTarget: "category",
      vAxis: {
        title: "Megabytes",
        viewWindow: {
          min: minWindow
        }
      },
      legend: {
        position: 'bottom'
      }
    };
    if (min == max) {
      opts.vAxis.viewWindow.max = 1.1 * max;
      opts.vAxis.viewWindow.min = 0.9 * max;
    }

    var chart = new google.visualization.LineChart(document.getElementById("chart_2"));

    chart.draw(dataTable, opts);
  },

  render: function() {
    return React.DOM.div({
      id: "chart_2",
      style: {
        height: "500px"
      }
    });
  }
});
*/
