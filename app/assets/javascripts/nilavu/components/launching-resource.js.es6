import { on, observes } from 'ember-addons/ember-computed-decorators';

import FlavorCost from 'nilavu/models/flavor_cost';

export default Ember.Component.extend({

    unittedFlavors: function() {
        return FlavorCost.all(this.get('resource'));
    }.property('resource')
});
