export default Ember.Component.extend({
    privateKey_suffix: ".key",
    publicKey_suffix: ".pub",
    spinnerIn: false,
    privatekeyType: "PRIVATE",
    publickeyType: "PUBLIC",
    privatekey: 'application/x-pem-key',
    publickey: 'text/plain',

    showSpinner: function() {
        return this.get('spinnerIn');
    }.property('spinnerIn'),

    showType: function() {
        return this.get('type').decamelize().capitalize();
    }.property('type'),

    _getSuffix(type) {
        if (type == this.get('privatekeyType')) {
            return this.get('privateKey_suffix');
        } else {
            return this.get('publicKey_suffix');
        }
    },

    actions: {

        download() {
            var self = this;
            this.set('spinnerIn', false);
            var blob = null;
            if (this.get('type') == this.get('privatekeyType')) {
                blob = new Blob([this.get('model').privatekey], {
                    type: this.get('privatekey')
                })
            } else {
                blob = new Blob([this.get('model').publickey], {
                    type: this.get('publickey')
                })
            }
            Nilavu.saveAs(blob, this.get('model.name') + this._getSuffix(this.get('type')));
        }
    }
});
