
var Sensors = React.createClass({

  getInitialState: function getInitialState() {

    $.getJSON("/sensors", function(result) {
      console.log("AJAX CALL---------------------->");
      console.log(result);
    }.bind(this));
  },
  render: function render() {
     return (<div>aaa</div>);
   }
});
