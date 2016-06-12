import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    change: function() {
        Ember.run.once(this, 'billingRegionChanged');
    }

});
