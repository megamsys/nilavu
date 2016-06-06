var Logs = React.createClass({

  getInitialState: function getInitialState() {
    return {
      messages: [],
      wait_text: "gobbling logs",
      loading: false,
    };
  },

  componentDidMount: function componentDidMount() {

    var socket = this.props.socket;
    socket.onopen = this._initialize
    socket.onmessage = this._messageRecieve


  },
  _initialize: function _initialize(data) {
    var socket = this.props.socket;
    var name = this.props.name;
    //socket.emit('message', name);
    var connJson = JSON.stringify({
      "Name": name
    })
    socket.send(connJson);
  },

  _messageRecieve: function _messageRecieve(message) {
    var messages = this.state.messages;
    var jsonData = JSON.parse(message.data);
    var jsonMsg = jsonData.Message
    var stripData = jsonMsg.slice(0, jsonMsg.length);
    var obj = JSON.parse(stripData)
    var log = jsonData.Timestamp + " " + obj.Message;
    messages.push(log);
    this.setState({
      messages: messages
    });
  },

  render: function render() {
    return React.createElement('div', null, React.createElement(MessageList, {
      messages: this.state.messages
    }
    ));
  }
});

var MessageList = React.createClass({
  displayName: 'MessageList',

  render: function render() {
  	var mapData = this.props.messages.map((message, i) => {
                      return (
                          <Message
                              key={i}
                              text={message}
                          />
                      );
                  });

  	return (
  		<div>
            {mapData}
            <LogLoader isActive={this.props.isLoading} />
        </div>
  	)
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

var LogLoader = React.createClass({
	 render: function render() {
    return (
    	<div>
      <img src="assets/pacman.gif" alt="gobbling logs"/><b> gobbling</b> logs...</div>
    )}
})
