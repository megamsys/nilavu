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
    buckets: Em.computed.alias('model'),

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
