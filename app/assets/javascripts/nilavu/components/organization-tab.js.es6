import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
  tagName: 'li',
  classNameBindings: ['active', 'tabClassName', ':tabDisabled'],

  tabClassName: function() {
    return 'org-' + this.get('orgTab');
  }.property('orgTab'),

  active: propertyEqual('orgSelectedTab', 'orgTab'),

  title: function() {
    return I18n.t('org.' + this.get('orgTab') + ".tab_title");
  }.property('orgTab'),

  _addToCollection: function() {
    this.get('orgPanels').addObject(this.get('tabClassName'));
  }.on('didInsertElement'),

  actions: {
    select: function() {
      this.set('orgSelectedTab', this.get('orgTab'));
    }
  }
});
