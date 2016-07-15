import ModalFunctionality from 'nilavu/mixins/modal-functionality';
import NilavuURL from 'nilavu/lib/url';
export default Ember.Controller.extend(ModalFunctionality, {
    createButton: true,
    spinnerIn: false,

    onShow: function() {
        this.set('controllers.modal.modalClass', 'ssh-modal');
    },

    placeHolder: function() {
        return I18n.t("ssh_keys.temp_name");
    }.property(),

    submitDisabled: function() {
        if (this.get('sshKeyCreateName')) return false;
        return true;
    }.property('sshKeyCreateName'),

    showSpinner: function() {
        return this.get('spinnerIn');
    }.property('spinnerIn'),

    actions: {
        create() {
          var self = this;
          this.set('spinnerIn', true);

          Nilavu.ajax('/ssh_keys', {
              data: {
                  ssh_keypair_name: this.get('sshKeyCreateName').trim()
              },
              type: 'POST'
          }).then(function(result) {
              self.set('spinnerIn', false);
              self.send("closeModal");
              if (result.success) {
                  self.notificationMessages.success(result.message);
                  /*self.get('model').reload().then(function(result) {
                      self.set('model', self.get('model').ssh);
                      console.log(self.get('model'));
                  }).catch(function(e) {
                      self.notificationMessages.error(I18n.t("ssh_keys.reload_error"));
                  });*/
              } else {
                  self.notificationMessages.error(result.message);
              }
          }).catch(function(e) {
              self.set('spinnerIn', false);
              self.send("closeModal");
              self.notificationMessages.error(I18n.t("ssh_keys.create_error"));
          });
        }
    },

});
