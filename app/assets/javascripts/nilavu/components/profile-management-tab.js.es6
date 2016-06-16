import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
  tagName: 'li',
  classNameBindings: ['active', 'tabClassName', ':tabDisabled'],


  tabClassName: function() {
    return 'profile-management-' + this.get('tab');
  }.property('tab'),

  active: propertyEqual('selectedTab', 'tab'),

  title: function() {
    return I18n.t('profile_management.' + this.get('tab') + ".tab_title");
  }.property('tab'),

  _addToCollection: function() {
    this.get('panels').addObject(this.get('tabClassName'));
  }.on('didInsertElement'),

  actions: {
    select: function() {
      this.set('selectedTab', this.get('tab'));
    }
  }
});
