import { propertyEqual, propertyNotEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
  tagName: 'li',
  classNameBindings: ['active', 'tabClassName',  'disabled:tabDisabled'],

  tabClassName: function() {
    return 'launching-image-' + this.get('tab');
  }.property('tab'),

  disabled: propertyNotEqual('selectedTab','tab'),

  active: propertyEqual('selectedTab', 'tab'),

  title: function() {
    return I18n.t('launcher.' + this.get('tab').replace('-', '_'));
  }.property('tab'),

  lowerTitle: function() {
      return this.get('title').toLowerCase();
  }.property('title'),

  _addToCollection: function() {
    this.get('imagepanels').addObject(this.get('tabClassName'));
  }.on('didInsertElement'),

  actions: {
    select: function() {
      this.set('selectedTab', this.get('tab'));
    }
  }
});
