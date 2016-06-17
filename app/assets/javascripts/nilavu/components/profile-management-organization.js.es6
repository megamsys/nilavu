import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('organization', {
  orgSelectedTab: null,
  orgPanels: null,

  _initPanels: function() {
      this.set('orgPanels', []);
      this.set('orgSelectedTab', 'user');
  }.on('init'),

  userSelected: function() {
    return this.orgSelectedTab == 'user';
  }.property('orgSelectedTab'),

  domainSelected: function() {
    return this.orgSelectedTab == 'domain';
  }.property('orgSelectedTab'),

});
