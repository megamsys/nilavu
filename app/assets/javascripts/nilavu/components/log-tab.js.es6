import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
  classNameBindings: ['active', 'tabClassName', ':tabDisabled', 'uibtnactive'],

  tabClassName: function() {
    return 'log-' + this.get('logTab');
  }.property('logTab'),

  active: propertyEqual('logSelectedTab', 'logTab'),

  uibtnactive: propertyEqual('logSelectedTab', 'logTab'),

  title: function() {
    return I18n.t('logs.' + this.get('logTab') + ".tab_title");
  }.property('logTab'),

  _addToCollection: function() {
    this.get('logPanels').addObject(this.get('tabClassName'));
  }.on('didInsertElement'),

  actions: {
    select: function() {
      this.set('logSelectedTab', this.get('logTab'));
    }
  }
});
