var Overview = React.createClass({
  getInitialState: function() { //json data
    return {
      JsonD: ''
    };
  },

  render: function() {
    return (
      <div >
        <OverviewTab google={this.props.google} host={this.props.host} mhost={this.props.mhost}/>
        <b className="logs-head">Logs</b>
        <div className="logBox borderless torpOverviewTb">

          <div className="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <Logs name={this.props.name} socket={this.props.socket}/>
          </div>
        </div>
      </div>

    );
  }
});

var MetricLoader = React.createClass({
	 render: function render() {
    return (
    	<div className="metricLoader"><img src="assets/spin_loader.GIF" alt="Wait" /></div>
    )}
})


var OverviewTab = React.createClass({
  getInitialState: function() { //json data
    return {
      isLoading: true,
      JsonD: '',
      machineInfo: ''
    };
  },

  componentDidMount: function() {
    this.updateData();
    $('.bar').hide();
    $('.spinner').hide();
    //setInterval(this.updateData, 2000);
    this.interval  = setInterval(this.updateData, 2000);
  },
  componentDidUpdate: function() {
  	$('.bar').hide();
  	$('.spinner').hide();
    this.drawCPU();
    this.drawRAM();
    this.drawNETWORK();
  },

    componentWillUnmount: function() {
      clearInterval(this.interval);
   },

  updateData: function() {
  	$.ajax({
  		url: this.props.host,
  		success: function(data) {
  					this.setState({  JsonD: data  });
  					$('.bar').hide();
  					$('.spinner').hide();
  					$('.metricLoader').hide();
     			}.bind(this),
  		error: function(xhr, status, err) {
    				$('.bar').hide();
    				$('.spinner').hide();
  				}.bind(this)
  	});

  	$.ajax({
  		url: this.props.mhost,
  		success: function(mdata) {
  					this.setState({  machineInfo: mdata, isLoading: false  });
  					$('.bar').hide();
  					$('.spinner').hide();
  					$('.metricLoader').hide();
     			}.bind(this),
  		error: function(xhr, status, err) {
    				$('.bar').hide();
    				$('.spinner').hide();
  				}.bind(this)
  	});

  },

   drawCPU: function() {
    var stats = this.state.JsonD;
    if (!this.hasResource(stats, "cpu")) {
      return;
    }

    var titles = [
      "Time", "Total"
    ];
    var data = [];
    for (var i = 1; i < stats.stats.length; i++) {

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
      width: 800,
      chartArea:{
      	left:110,
      	top:5,
      	},
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
    var chart = new this.props.google.visualization.LineChart(document.getElementById("cpu_chart"));

    chart.draw(dataTable, opts);

  },

  drawRAM: function() {
    var stats = this.state.JsonD;
    var machineInfo = this.state.machineInfo;

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
    console.log(data);
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
      width: 800,
      chartArea:{
      	left:110,
      	top:5,
      	},
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
    var chart = new google.visualization.LineChart(document.getElementById("ram_chart"));
    chart.draw(dataTable, opts);
  },

  drawNETWORK: function() {
    var stats = this.state.JsonD;
    for (var i = 1; i < 10; i++) {
      console.log(stats.stats[i].network.interfaces);
    }
    if (stats.spec.has_network && !this.hasResource(stats, "network")) {
      return;
    }
    var interfaceIndex = -1;
    if (stats.stats.length > 0) {
      interfaceIndex = this.getNetworkInterfaceIndex("eth0", stats.stats[0].network.interfaces);
    }
    if (interfaceIndex < 0) {
      console.log("Unable to find interface\"", interfaceName, "\" in ", stats.stats.network);
      return;
    }
    var titles = [
      "Time", "Tx bytes", "Rx bytes"
    ];
    var data = [];
    for (var i = 1; i < stats.stats.length; i++) {
      var cur = stats.stats[i];
      var prev = stats.stats[i - 1];
      var intervalInSec = this.getInterval(cur.timestamp, prev.timestamp) / 1000000000;
      var elements = [];
      elements.push(cur.timestamp);
      elements.push((cur.network.interfaces[interfaceIndex].tx_bytes - prev.network.interfaces[interfaceIndex].tx_bytes) / intervalInSec);
      elements.push((cur.network.interfaces[interfaceIndex].rx_bytes - prev.network.interfaces[interfaceIndex].rx_bytes) / intervalInSec);
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
      width: 800,
      chartArea:{
      	left:110,
      	top:5,
      	},
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

    var chart = new this.props.google.visualization.LineChart(document.getElementById("network_chart"));
    chart.draw(dataTable, opts);

  },

  hasResource: function(stats, resource) {
    return stats.stats.length > 0 && stats.stats[0][resource];
  },

  getNetworkInterfaceIndex: function(interfaceName, interfaces) {
    for (var i = 0; i < interfaces.length; i++) {
      if (interfaces[i].name == interfaceName) {
        return i;
      }
    }
    return -1;
  },

  getInterval: function(current, previous) {
    var cur = new Date(current);
    var prev = new Date(previous);

    return (cur.getTime() - prev.getTime()) * 1000000;
  },


  render: function() {
    return (

      <div className="tabbable-custom nav-justified margintb_15">
    <ul className="nav nav-tabs nav-justified">
        <li className="active">
            <a href="#cpu_tab" data-toggle="tab"> CPU </a>
        </li>
        <li>
            <a href="#ram_tab" data-toggle="tab"> RAM </a>
        </li>
        <li>
            <a href="#network_tab" data-toggle="tab"> Network </a>
        </li>
    </ul>
    <div className="tab-content c_tab-content">

        <div className="tab-pane active" id="cpu_tab">
            <div className="">
                <div className="demo-container">
                    <MetricLoader isActive={this.state.isLoading} />
                    <div id="cpu_chart" className="demo-placeholder" ></div>
                </div>
            </div>
        </div>
        <div className="tab-pane" id="ram_tab">
            <div className="demo-container">
                <MetricLoader isActive={this.state.isLoading} />
                <div id="ram_chart" className="demo-placeholder" ></div>
            </div>
        </div>
        <div className="tab-pane" id="network_tab">
        	<div className="demo-container">
        	    <MetricLoader isActive={this.state.isLoading} />
                <div id="network_chart" className="demo-placeholder" ></div>
            </div>
        </div>
    </div>
</div>

    );
  }
});
