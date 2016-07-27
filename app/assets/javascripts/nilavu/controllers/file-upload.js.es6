import ModalFunctionality from 'nilavu/mixins/modal-functionality';
import showModal from 'nilavu/lib/show-modal';
export default Ember.Controller.extend(ModalFunctionality, {
    needs: ['modal'],
    spinnerIn: false,
    fileuploaders: [],
    object: null,

    onShow() {
        this.set('controllers.modal.modalClass', 'full');
    },

    actions: {
        startUpload() {
          this.get('fileuploaders').pushObject(Ember.Object.create({
              bucket_name: this.get('bucketName'),
              access_key: this.get('access_key'),
              secret_key: this.get('secret_key'),
          }));
        },

    }
});
