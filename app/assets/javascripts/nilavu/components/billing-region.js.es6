import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

  billingRegions: function() {
      var rval = [];
      _.each(this.get("regions"), function(p) {
          rval.addObject({
              name: p.name,
              value: p.name
          });
      });
      return rval;
  }.property("regions"),

});
