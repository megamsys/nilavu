import ModalFunctionality from 'nilavu/mixins/modal-functionality';
export default Ember.Controller.extend(ModalFunctionality, {
    needs: ['modal'],
    spinnerIn: false,

    onShow() {
        this.set('controllers.modal.modalClass', 'custom-modal full');
    },

    // You need a value in the field to submit it.
    submitDisabled: function() {
        return Ember.isEmpty((this.get('bucketName') || '').trim()) || this.get('disabled');
    }.property('bucketName', 'disabled'),

    showSpinner: function() {
        return this.get('spinnerIn');
    }.property('spinnerIn'),


    actions: {

        create() {
            var self = this;
            this.set('spinnerIn', true);
            if (this.get('submitDisabled')) return false;

            Nilavu.ajax('/buckets', {
                data: {
                    id: this.get('bucketName').trim()
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
                self.notificationMessages.error(I18n.t("bucket.bucket_create_error"));
            });
        },

    }
});
