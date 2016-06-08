import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';
export default Ember.Component.extend({

    /*regions: Em.computed.alias('model.regions'),

    regionName: Ember.computed.alias('region.name'),

      showRegions: function() {
        console.log("*****show region******");
      alert(JSON.stringify(this.get('model.regions')));
    }.property('model.regions')*/
    billingRegionChanged: function() {
        console.log("*********");
        this.set('ram', this.get('billingRegionoption'));
    },

    change: function() {
        Ember.run.once(this, 'billingRegionChanged');
    }

});
