var ModalTrigger = React.createClass({
    handleClick: function(e) {
        $(this.refs.payload.getDOMNode()).modal();
    },
    render: function() {
        var Trigger = this.props.trigger;
        return (<div onClick={this.handleClick}>
            <Trigger/>
            <Modal ref="payload"
                header={this.props.header}
                body={this.props.body}
                footer={this.props.footer}>
            </Modal>;
        </div>);
    },
});

var Modal = React.createClass({
    componentDidMount: function() {
        // Initialize the modal, once we have the DOM node
        // TODO: Pass these in via props
        $(this.getDOMNode()).modal({background: true, keyboard: true, show: false});
    },
    componentWillUnmount: function() {
        $(this.getDOMNode()).off('hidden');
    },
    // This was the key fix --- stop events from bubbling
    handleClick: function(e) {
        e.stopPropagation();
    },
    render: function() {
        var Header = this.props.header;
        var Body = this.props.body;
        var Footer = this.props.footer;
        return (
            <div onClick={this.handleClick} className="modal fade" role="dialog" aria-hidden="true">
                <div className="modal-dialog">
                    <div className="modal-content">
                        <Body className="modal-header"/>
                    </div>
                </div>
            </div>
        );
    }
});

var Controller = React.createComponent({
    renderHidden: function(component) {
        var hidden = this.refs.hiddenNodes;
        hidden.setState({
            childNodes: hidden.state.childNodes.concat(hidden.childNodes, [component])
        });
    },

   render: function() {
     <div className="container-fluid">
        <HiddenNodes ref="hiddenNodes">
        </HiddenNodes>
        <div>
           <h1>Hello possums</h1>
           <div>
              <ModalTrigger trigger={MyTriggerAsset} body={MyBodyAsset} modalID={"arbitraryString"} renderTo={this.renderHidden}/>
           </div>
        </div>
     </div>
   }
});

var HiddenNodes = React.createClass({
    getInitialState: function() {
        return {childNodes: []};
    },

    render: function() {
      return (<div>{this.state.childNodes}</div>);
    }
});

var ModalTrigger = React.createClass({
    handleClick: function(e) {
        $('[data-modal=' + this.props.modalID + ']').modal();
    },
    render: function() {
        var Trigger = this.props.trigger;
        return (<div onClick={this.handleClick}><Trigger/></div>);
    },
    componentDidMount: function() {
        this.props.renderTo(<Modal modalID={this.props.modalID} body={this.props.body}></Modal>);
    }
});

var ModalPayload = React.createClass({
    componentDidMount: function() {
        // These can be configured via options; this is just a demo
        $(this.getDOMNode()).modal({background: true, keyboard: true, show: false});
    },

    componentWillUnmount: function() {
        $(this.getDOMNode()).off('hidden', this.handleHidden);
    },

    render: function() {
        return {Header: React.DOM.div, Body: React.DOM.div, Footer: React.DOM.div};
    },
    render: function() {
        var Header = this.props.header;
        var Body = this.props.body;
        var Footer = this.props.footer;
        return (
            <div className="modal fade" role="dialog" aria-hidden="true" data-modalID={this.props.modalID}>
                <div className="modal-dialog">
                    <div className="modal-content">
                        <Header className="modal-header"/>
                        <Body className="modal-body"/>
                        <Footer className="modal-footer"/>
                    </div>
                </div>
            </div>
        );
    }
});
