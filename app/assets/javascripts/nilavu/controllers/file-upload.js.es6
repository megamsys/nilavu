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
        uploadSelectorAction() {
            showModal('uploadSelector').setProperties({
                toolbarEvent,
                imageUrl: null,
                imageLink: null
            });
        },

        upload(object) {
            this.get('fileuploaders').pushObject(Ember.Object.create({
                object: this.get('object'),
            }));
        },

        startUpload() {
          this.get('fileuploaders').pushObject(Ember.Object.create({
              object: this.get('object'),
          }));
        },

    }
});
