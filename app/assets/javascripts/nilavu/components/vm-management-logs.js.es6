import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import { on, computed, observes } from  'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('logs', {
  logSelectedTab: null,
  logPanels: null,
  socket: null,

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
    this.set('socket', this.websockets.socketFor('ws://localhost:7777/logs'));

    if (this.websockets.isWebSocketOpen(this.get('socket'))) {
      alert(this.websockets.isWebSocketOpen(this.get('socket')));
      //this.get('socket').send({
      //  Name: this.get('model.name'),
      //}, true);
    }
  },

  _socket_disconnect: function() {
    var socket = this.get('socket');
    socket.close();
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
