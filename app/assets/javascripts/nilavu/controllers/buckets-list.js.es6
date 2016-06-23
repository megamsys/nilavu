import showModal from 'nilavu/lib/show-modal';
import Buckets from 'nilavu/models/buckets';

export default Ember.Controller.extend({
    title: "Storages",
    viewIcons: false,
    loading: false,

    actions: {
      bucketCreate() {
          showModal('storageBucket', {
              title: 'bucket.title',
              smallTitle: true,
              titleCentered: true
          });
      },

      create() {
          this._save();

      }
    }
});
