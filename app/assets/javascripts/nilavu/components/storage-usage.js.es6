import {
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  spinnerUsageIn: false,
  usage: Em.computed.alias('buckets.message.spaced'),
  totalStorage: Em.computed.alias('buckets.message.spaced.buckets_size_humanized'),
  totalBuckets: Em.computed.alias('buckets.message.spaced.buckets_count'),

  _initializeSimilar: function() {
      this.set('spinnerUsageIn', true);
  }.on('init'),

  showUsageLoading: function() {
      return this.get('spinnerUsageIn');
  }.property('spinnerUsageIn'),

  @observes('usage')
  listShow() {
      this.set('spinnerUsageIn', false);
  },

});
