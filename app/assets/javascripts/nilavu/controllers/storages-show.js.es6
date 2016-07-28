import showModal from 'nilavu/lib/show-modal';
import Bucketfiles from 'nilavu/models/bucketfiles';
export default Ember.Controller.extend({
  title: "Your Files",
  loading: false,
  bucketfiles: Em.computed.alias('model'),
  bucket_name: Em.computed.alias('model.message.bucket_name'),
  access_key: Em.computed.alias('model.auth_keys.access_key'),
  secret_key: Em.computed.alias('model.auth_keys.secret_key'),

  actions: {
      upload() {
          showModal('fileUpload', {
              title: 'bucket.file',
              smallTitle: true,
              titleCentered: false
          }).setProperties({
              bucketName: this.get('bucket_name'),
              access_key: this.get('access_key'),
              secret_key: this.get('secret_key'),
          });
      }
  },

});
