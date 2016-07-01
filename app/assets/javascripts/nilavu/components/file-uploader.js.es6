import {
    formatFileIcons,
    formatFileSize
} from 'nilavu/helpers/file-formats';
import {
    generateSignature
} from 'nilavu/helpers/storage';
export default Ember.Component.extend({
    spinnerConnectIn: false,
    storageAction: null,
    storageKey: null,
    storageACL: 'public-read',
    storageContentType: null,
    storageAccessKeyId: null,
    storagePolicy: null,
    storageSignature: null,

    fileName: function() {
        return this.get('model').file[0].name;
    }.property('model'),

    fileSize: function() {
        return formatFileSize(this.get('model').file[0].size);
    }.property('model'),

    iconClass: function() {
        var nameSplit = this.get('model').file[0].name.split('.');
        return formatFileIcons(nameSplit[nameSplit.length - 1]);
    }.property('model'),

    popIcon: function() {
        return "pop_icon";
    }.property(),

    showConnectSpinner: function() {
        return this.get('spinnerConnectIn');
    }.property('spinnerConnectIn'),

    formAction: function() {
        return this.get('storageAction');
    }.property('storageAction'),

    formKey: function() {
        return this.get('storageKey');
    }.property('storageKey'),

    formACL: function() {
        return this.get('storageACL');
    }.property('storageACL'),

    formContentType: function() {
        return this.get('storageContentType');
    }.property('storageContentType'),

    formAccessKey: function() {
        return this.get('storageAccessKeyId');
    }.property('storageAccessKeyId'),

    formSignature: function() {
        return this.get('storageSignature');
    }.property('storageSignature'),

    formPolicy: function() {
        return this.get('storagePolicy');
    }.property('storagePolicy'),

    didInsertElement() {
        this._serverConnect();
    },

    _serverConnect() {
        const self = this;
        const bucketName = "sam";
        this.set('spinnerConnectIn', true);
        Nilavu.ajax('/buckets/'+bucketName, {
            type: 'GET'
        }).then(function(result) {
            if (result.success) {
                self.set('storageAction', result.message.storage_url+'/'+bucketName);
                self.set('storageKey', self.get('fileName'));
                self.set('storageACL', self.get('storageACL'));
                self.set('storageContentType', '');
                self.set('storageAccessKeyId', result.message.access_key_id);
                var sign = generateSignature({
                    "bucketName": "sam",
                    "acl": self.get('storageACL'),
                    "name": self.get('fileName'),
                    "access_key": result.message.access_key_id,
                    "secret_access_key": result.message.secret_access_key,
                });
                self.set('storagePolicy', sign.policy);
                self.set('storageSignature', sign.signature);
            } else {
                self.notificationMessages.error(result.message);
            }
        });
    },

    _uploadFile(file, signedRequest) {
        return new Promise(function(resolve, reject) {
            const xhr = new XMLHttpRequest()
            xhr.open("PUT", signedRequest)
            xhr.setRequestHeader('x-amz-acl', 'public-read')
            xhr.setRequestHeader('Access-Control-Allow-Origin', '*')
            xhr.onload = () => {
                resolve()
            }
            xhr.send(file)
        })
    },


});
