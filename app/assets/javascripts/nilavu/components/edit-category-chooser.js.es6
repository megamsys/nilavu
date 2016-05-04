import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  classNameBindings: ['isActive:active'],

  launchableName: Ember.computed.alias('name'),

  alignRight: function() {
    const posRight  = this.get('position') || "";
    return posRight.trim();
  }.property('position'),

  showLaunchableImage: function() {
    return this.get('launchableName') + '.png';
  }.property('launchableName'),

  isActive: function() {
    alert("isActive: "+ "," + this.get('launchableName'));
    const launchable = this.get('launchable') || "";
    alert("isAction: " + ", l ="+ this.get('launchable'));

    return launchable.trim().length > 0;
  }.property("launchable"),

  @observes('value')
  valueChanged() {
    alert("value changed");
    this.set('selectedLaunchable',this.get('value'))
  }

});
