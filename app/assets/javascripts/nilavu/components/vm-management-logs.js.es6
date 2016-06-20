import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import { on, computed } from  'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('logs', {
  logSelectedTab: null,
  logPanels: null,

  _initPanels: function() {
      this.set('logPanels', []);
      this.set('logSelectedTab', 'all');
  }.on('init'),

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
