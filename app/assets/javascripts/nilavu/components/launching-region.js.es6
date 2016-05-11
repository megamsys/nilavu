import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  classNameBindings: ['isActive:active'],

  regionName: Ember.computed.alias('region.name'),

  regionFlag: Ember.computed.alias('region.flag'),

  isActive: function() {
    const region = this.get('regionSelected') || "";
    return region.trim().length > 0 && region.trim() == this.get('regionName');
  }.property("regionSelected"),


  myStyle: Ember.computed('display', function() {
      return Ember.String.htmlSafe("display:none");
  }),

  actions: {
    showResources: function() {
    //    alert("selected " + this.get('regionSelected'));
    }
  }

});
