import {
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  totalStorage: Em.computed.alias('bucketfiles.message.spaced.buckets_size_humanized'),
  totalObjects: Em.computed.alias('bucketfiles.message.spaced.buckets_count'),

});
