import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({

    regionName: Ember.computed.alias('region.name'),
    regionFlag: Ember.computed.alias('region.flag')

});
