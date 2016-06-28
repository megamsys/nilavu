import showModal from 'nilavu/lib/show-modal';

export default Ember.Controller.extend({
  title: "Your Files",
  loading: false,

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
