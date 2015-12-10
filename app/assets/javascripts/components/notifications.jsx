var Noti = React.createClass({
  getInitialState: function getInitialState() {
    return {
      events: [],
      incoming: '',
      icon: false
    };
  },

  handleClick: function(e) {
    if (this.getDOMNode().contains(e.target)) {
      return;
    }
  },

  componentDidMount: function() {
    //this.getEvent()
    //setInterval(this.getEvent, 8000);
  },

  componentDidUpdate: function() {
    var events = this.state.events;
    events.push(this.state.incoming)
    if (events.length >= 3) {
      for (var i = 0; i < 2; i++) {
        events.shift()
      }
      this.setState({
        events: events
      });
    }
  },

  getEvent: function() {
    $.getJSON("/sensors", function(response) {
      if (response == "error") {
        this.setState({
          icon: true
        });
      }
      this.setState({
        incoming: response
      });
    }.bind(this));
  },

  render: function() {
    return (
      <div>
        <li>
          <p>
            Your notifications
          </p>
        </li>
        <li>
         
        </li>
        <li className="external">
          <a href="#">See all notifications
            <i className="m-icon-swapright"></i>
          </a>
        </li>
      </div>
    );
  }
});

var Single = React.createClass({

  getInitialState: function getInitialState() {
    return {
      items: [],
      prefix: '',
      data: ''
    }
  },
  componentWillUpdate: function() {
    if (this.props.icon) {
      this.setState({
        cname: this.spanFuncFailure(),
        prefix: "Your instance is",
        data: this.props.data
      });
    } else {
      this.setState({
        cname: this.spanFuncSuccess(),
        prefix: "Your instance is",
        data: this.props.data
      });
    }
  },

  spanFuncSuccess: function() {
    return (
      <span className="label label-sm label-icon label-success">
        <i className="icon-plus"></i>
      </span>
    );
  },
  spanFuncFailure: function() {
    return (
      <span className="label label-sm label-icon label-danger">
        <i className="icon-bolt"></i>
      </span>
    );
  },

  render: function() {
    return (
      <li>
        <a href="#">
          {this.state.cname} {this.state.prefix} {this.state.data}
        </a>
      </li>
    );
  }
});



 //<ul className="dropdown-menu-list scroller">
           // {this.state.events.map(function (oneEvent) {
            //  return (
            //    <Single data={oneEvent} icon={this.state.icon}/>
            //  );
           // }.bind(this))}
          //</ul>