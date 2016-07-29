import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import {
    on,
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('logs', {
    logSelectedTab: null,
    logPanels: null,
    log_socket: null,
    messages: null,

    _initPanels: function() {
        this.set('logPanels', []);
        this.set('logSelectedTab', 'all');
    }.on('init'),

    @observes('selectedTab')
    tabChanged() {
        if (Ember.isEqual(this.get('selectedTab'), "logs")) {
            this._socket_connect();
        } else {
            this._socket_disconnect();
        };
    },

    _socket_connect: function() {
        this.set('log_socket', this.socketIO.socketFor(Nilavu.LogServer, {
            path: "/logs"
        }));
        var socket = this.get('log_socket');
        socket.emit("category_connect", "log");
        socket.emit('logInit', this.get('model.name'));
        socket.on(this.get('model.name'), this.onMessage, this);
        socket.on('error', this.onErrorMessage, this);
    },


    onMessage: function(data) {
        this.set('message', data);
    },

    onErrorMessage: function(data) {
        this.notificationMessages.error(data);
    },

    _socket_disconnect: function() {
        var socket = this.get('log_socket');
        if (!Ember.isEqual(this.get('log_socket'), null)) {
            socket.emit('logDisconnect', "disconnect");
            socket.close();
        }
    },

    willDestroyElement: function() {
        this._socket_disconnect();
    },

    allSelected: function() {
        return this.logSelectedTab == 'all';
    }.property('logSelectedTab'),

    actionsSelected: function() {
        return this.logSelectedTab == 'actions';
    }.property('logSelectedTab'),

    warningsSelected: function() {
        return this.logSelectedTab == 'warnings';
    }.property('logSelectedTab'),

    errorsSelected: function() {
        return this.logSelectedTab == 'errors';
    }.property('logSelectedTab')

});
