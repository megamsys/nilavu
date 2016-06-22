import ModalFunctionality from 'nilavu/mixins/modal-functionality';
export default Ember.Controller.extend(ModalFunctionality,{
  needs: ['modal'],
onShow() {
    this.set('controllers.modal.modalClass', 'ssh-modal full');

}

});
