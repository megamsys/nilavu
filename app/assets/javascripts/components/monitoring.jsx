var Monitoring = React.createClass({

  getInitialState: function getInitialState() {
    return {
      JsonData: []
    };
  },

  componentDidMount: function() {
    console.log("----");
    console.log(this.props.d3);
    console.log("----");

    setInterval(this.updateData, 1000);

  },

  updateData: function() {
    console.log("inside updatedata");
    var BarChart = this.props.d3.BarChart;
  console.log(BarChart);



    $.get(this.props.host, function(result) {
      console.log(result);
      var newData = result;
      if (this.isMounted()) {
        this.setState({
          cores: newData.num_cores,
          memory: newData.memory_capacity
        });
      }

    }.bind(this));

  },

  render: function() {
        return <div>asd</div>;
  }
});
