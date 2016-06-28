import ModalFunctionality from 'nilavu/mixins/modal-functionality';
import showModal from 'nilavu/lib/show-modal';
export default Ember.Controller.extend(ModalFunctionality, {
    needs: ['modal'],
    spinnerIn: false,
    fileselectors: [{
      upload: true,
    }],

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

        addSelector() {
          this.get('fileselectors').push({
            upload: true,
          });
        }

    }
});
