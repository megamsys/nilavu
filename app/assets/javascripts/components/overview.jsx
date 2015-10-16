var CPU = 'cpu';
var Memory = 'memory';
var Network = 'network';
var tabList = [
  {
    'id': 1,
    'name': 'CPU',
    'url': '/cpu'
  }, {
    'id': 2,
    'name': 'RAM',
    'url': '/ram'
  }, {
    'id': 3,
    'name': 'NETWORK',
    'url': '/network'
  }
];

var Tab = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.props.handleClick();
  },

  render: function() {
    return (
      <li className={this.props.isCurrent
        ? 'current chart-tab'
        : null}>
        <a data-toggle="tab" href={this.props.url} onClick={this.handleClick}>
          {this.props.name}
        </a>
      </li>
    );
  }
});

var Tabs = React.createClass({
  handleClick: function(tab) {
    this.props.changeTab(tab);
  },

  render: function() {
    return (
      <div className="nav-justified margintb_15">

      <ul className="nav nav-tabs nav-justified">
        {this.props.tabList.map(function (tab) {
          return (
            <Tab handleClick={this.handleClick.bind(this, tab)} isCurrent={(this.props.currentTab === tab.id)} key={tab.id} name={tab.name} url={tab.url}/>
          );
        }.bind(this))}
      </ul>
      </div>
    );
  }
});

var Overview = React.createClass({
  getInitialState: function() { //json data
    return {
      cpu: CPU,
      memory: Memory,
      network: Network,
      tabList: tabList,
      currentTab: 1,
      JsonD: ''
    };
  },

  changeTab: function(tab) {
    this.setState({
      currentTab: tab.id
    });
  },

  render: function() {
    return (
      <div className=" nav-justified margintb_15">
          <Tabs changeTab={this.changeTab} currentTab={this.state.currentTab} tabList={this.state.tabList}/>
          <Content JsonD={this.state.JsonD} currentTab={this.state.currentTab} google={this.props.google} host={this.props.host} mhost={this.props.mhost}/>
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

var Content = React.createClass({

  render: function() {
    return (
      <div class="tab-content c_tab-content">
        {this.props.currentTab === 1
          ? <div className="tab-pane cpu">
                <div className="demo-container">
                  <Charts google={this.props.google} host={this.props.host} mhost={this.props.mhost} name={"cpu"}/>
              </div>
            </div>
          : null}

        {this.props.currentTab === 2
          ? <div className="tab-pane ram">
              <div className="">
                <div className="demo-container">
                  <Charts google={this.props.google} host={this.props.host} mhost={this.props.mhost} name={"ram"}/>
                </div>
              </div>
            </div>
          : null}

        {this.props.currentTab === 3
          ? <div className="tab-pane cpu">
              <div className="">
                <div className="demo-container">
                  <Charts google={this.props.google} host={this.props.host} mhost={this.props.mhost} name={"network"}/>
                </div>
              </div>
            </div>
          : null}

      </div>
    );
  }
});

var Charts = React.createClass({

  getInitialState: function getInitialState() {
    return {
      JsonD: '',
      machineInfo: ''
    };
  },

  componentDidMount: function() {
    this.updateData();

    setInterval(this.updateData, 2000);

  },
  componentDidUpdate: function() {
    if (this.props.name == "cpu") {
      this.drawCPU();
    } else if (this.props.name == "ram") {
      this.drawRAM();
    } else {
      this.drawNETWORK();
    }

  },

  updateData: function() {
    $.get(this.props.host, function(data) {

      this.setState({
        JsonD: data
      })
    }.bind(this));
    $.get(this.props.mhost, function(mdata) {
      this.setState({
        machineInfo: mdata
      })
    }.bind(this));

  },

  drawCPU: function() {
    var stats = this.state.JsonD;
    if (stats.spec.has_cpu && !this.hasResource(stats, "cpu")) {
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
      height: 200,
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

    var chart = new this.props.google.visualization.LineChart(document.getElementById("chart"));

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
      height: 200,
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
    var chart = new google.visualization.LineChart(document.getElementById("chart"));
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
      height: 200,
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

    var chart = new this.props.google.visualization.LineChart(document.getElementById("chart"));
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
      <div>
        <div id="chart"></div>
      </div>

    );
  }
});
