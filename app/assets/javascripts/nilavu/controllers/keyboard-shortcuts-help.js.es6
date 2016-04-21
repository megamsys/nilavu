import ModalFunctionality from 'nilavu/mixins/modal-functionality';

export default Ember.Controller.extend(ModalFunctionality, {
  needs: ['modal'],

  onShow: function() {
    this.set('controllers.modal.modalClass', 'keyboard-shortcuts-modal');
  }
});
