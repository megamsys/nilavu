import ModalFunctionality from 'nilavu/mixins/modal-functionality';
export default Ember.Controller.extend(ModalFunctionality, {
    needs: ['modal'],
    title: "SSH Keys",

    name: function() {
       var model = this.get('model.message');
       return model;
    }.property('model'),


  onShow() {
        this.set('controllers.modal.modalClass', 'ssh-modal');

    },
  });
