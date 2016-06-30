import showModal from 'nilavu/lib/show-modal';
import Bucketfiles from 'nilavu/models/bucketfiles';
export default Ember.Controller.extend({
  title: "Your Files",
  loading: false,
  bucketfiles: Em.computed.alias('model'),

  actions: {
      upload() {
          showModal('fileUpload', {
              title: 'bucket.file',
              smallTitle: true,
              titleCentered: false
          });
      }
  },

});
