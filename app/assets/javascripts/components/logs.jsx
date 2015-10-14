var Logs = React.createClass({

  getInitialState: function getInitialState() {
    return {
      messages: []
    };
  },

  componentDidMount: function componentDidMount() {

    var socket = this.props.socket;
    socket.on('connect', this._initialize);
    socket.on('message', this._messageRecieve);

  },
  _initialize: function _initialize(data) {
    var socket = this.props.socket;
    var name = this.props.name;
    socket.emit('message', name);
  },

  _messageRecieve: function _messageRecieve(message) {
    var messages = this.state.messages;
    console.log(message)
    messages.push(message);
    this.setState({
      messages: messages
    });
  },

  render: function render() {
    return React.createElement('div', null, React.createElement(MessageList, {
      messages: this.state.messages
    }));
  }
});

var MessageList = React.createClass({
  displayName: 'MessageList',

  render: function render() {
    return React.createElement('div', { className: ''
    }, React.createElement('br'), this.props.messages.map(function(message, i) {
      return React.createElement(Message, {
        key: i,
        text: message.logs
      });
    }));
  }
});

var Message = React.createClass({
  displayName: 'Message',

  render: function render() {
    return React.createElement('div', {
      className: 'Message'
    }, React.createElement('span', null, this.props.text));
  }
});
