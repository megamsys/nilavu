import showModal from 'nilavu/lib/show-modal';
import Buckets from 'nilavu/models/buckets';
import {
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';
export default Ember.Controller.extend({
    title: "Storages",
    viewIcons: false,
    loading: false,
    spinnerListBucketIn: false,
    buckets: Em.computed.alias('model'),

    _initializeSimilar: function() {
        this.set('spinnerListBucketIn', true);
    }.on('init'),

    showListBucketLoading: function() {
        return this.get('spinnerListBucketIn');
    }.property('spinnerListBucketIn'),

    @observes('buckets')
    listShow() {
        this.set('spinnerListBucketIn', false);
    },

    actions: {
      bucketCreate() {
          showModal('bucketCreate', {
              title: 'bucket.title',
              smallTitle: true,
              titleCentered: true
          });
      },
    }
});
