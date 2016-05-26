import {  on,  observes } from 'ember-addons/ember-computed-decorators';
import { propertyEqual } from 'nilavu/lib/computed';

export default Ember.Component.extend({
  tagName: 'div',
  classNameBindings: [':tab-pane','isActive:active'],

  virtualmachines: Ember.computed.alias('category.cooking.virtualmachines'),

  launchableName: function() {
      return this.get('name').split('-').pop()
  }.property('name'),

  formatLaunchable: function(name) {
    const out = this.get('virtualmachines').map(function(v) {
      if (v.name.toLowerCase() == name) {
          return v.versions.map((ver) => [name,ver].join('_'));
      }
      return [];
    }).filter((f) => f.length > 0);

    var flattened = out.reduce(function(a, b) {
      return a.concat(b);
    }, []);

    return flattened;
  },

  versionChanged: function() {
    const lve = this.formatLaunchable(this.get('launchableName'));
    this.set('cookingVersions', lve);
  }.observes('category.cooking'),

  versions: function() {
    return this.get('cookingVersions');
  }.property('cookingVersions'),

  isActive: function() {
    const ln = this.get('launchableName');
    return ln.trim().length > 0 && ln.trim() == this.get('selectedTab');
  }.property('selectedTab')

});
