import ModalFunctionality from 'nilavu/mixins/modal-functionality';
export default Ember.Controller.extend(ModalFunctionality, {
    createButton: true,
    spinnerIn: false,
    sshPrivateKeyValue: null,
    sshPublicKeyValue: null,

    onShow: function() {
        this.set('controllers.modal.modalClass', 'ssh-modal');
    },

    placeHolder: function() {
        return I18n.t("ssh_keys.temp_name");
    }.property(),

    submitDisabled: function() {
        if (this.get('sshKeyImportName')) return false;
        return true;
    }.property('sshKeyImportName'),

    showSpinner: function() {
        return this.get('spinnerIn');
    }.property('spinnerIn'),

    actions: {
        sshkey_import() {
            var self = this;
            this.set('spinnerIn', true);
            Nilavu.ajax('/ssh_keys/import', {
                data: {
                    ssh_keypair_name: self.get('sshKeyImportName').trim(),
                    ssh_private_key: self.get('sshPrivateKeyValue'),
                    ssh_public_key: self.get('sshPublicKeyValue')
                },
                type: 'POST'
            }).then(function(result) {
                self.set('spinnerIn', false);
                self.send("closeModal");
                if (result.success) {
                    self.notificationMessages.success(result.message);
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
