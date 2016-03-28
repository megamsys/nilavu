import ModalFunctionality from 'nilavu/mixins/modal-functionality';

export default Ember.Controller.extend(ModalFunctionality, {
  emailSent: false,

  onShow() {
    this.set("emailSent", false);
  },

  actions: {
    sendActivationEmail: function() {
      Nilavu.ajax('/users/action/send_activation_email', {data: {username: this.get('username')}, type: 'POST'});
      this.set('emailSent', true);
    }
  }

});
