export default Ember.Component.extend({
    /*spinnerPrivateIn: false,
    spinnerPublicIn: false,
    privatekeyType: "PRIVATEKEY",
    publickeyType: "PUBLICKEY",
    privatekey: 'application/x-pem-key',
    publickey: 'text/plain',

    privateKey: function() {

        return this._filterInputs("sshkey");
    }.property('model.inputs'),

    publicKey: function() {
        return this._filterInputs("sshkey");
    }.property('model.inputs'),*/

    actions: {

        download() {
            alert(JSON.stringify(this.get('model')));
        }
    }
});
