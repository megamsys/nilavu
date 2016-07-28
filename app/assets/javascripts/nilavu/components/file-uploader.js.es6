import {
    generateSignature
} from 'nilavu/helpers/storage';
import {
    formatFileIcons,
    formatFileSize
} from 'nilavu/helpers/file-formats';
import {
    on
} from 'ember-addons/ember-computed-decorators';
export default Ember.Component.extend({
    spinnerConnectIn: false,
    storageACL: 'public-read',
    storageAccessKeyId: null,

    objectName: null,
    objectSize: null,
    objectIcon: null,
    signingUrl: '',

    filekey: null,
    fileaccesskey: null,
    filepolicy: null,
    filesignature: null,

    uploadPercentage: 0,
    progressPosition: 0,
    maxProgressPosition: 100,
    bucket_name: Em.computed.alias('model.bucket_name'),
    access_key: Em.computed.alias('model.access_key'),
    secret_key: Em.computed.alias('model.secret_key'),

    @on('didInsertElement')
    _initialize() {
        const self = this;
        $('#objectfile').trigger('click');
        this._bindUploadTarget();
    },

    bucketName: function() {
        return this.get('bucket_name');
    }.property(),

    fileName: function() {
        return this.get('objectName');
    }.property('objectName'),

    fileSize: function() {
        //  return formatFileSize(this.get('model').file[0].size);
        return this.get('objectSize');
    }.property('objectSize'),

    iconClass: function() {
        //var nameSplit = this.get('model').file[0].name.split('.');
        //return formatFileIcons(nameSplit[nameSplit.length - 1]);
        return this.get("objectIcon");
    }.property('objectIcon'),

    popIcon: function() {
        return "pop_icon";
    }.property(),

    showConnectSpinner: function() {
        return this.get('spinnerConnectIn');
    }.property('spinnerConnectIn'),

    _bindUploadTarget() {
        //this._unbindUploadTarget(); // in case it's still bound, let's clean it up first
        const self = this;
        const $element = this.$("#fileformupload");
        $element.fileupload({
            url: "https://madai.megam.io",
            pasteZone: $element,
            //forceIframeTransport: true,
            autoUpload: true,
            dataType: 'xml',
            type: 'POST',
        });

        $element.on('fileuploadsubmit', (e, data) => {
            var sign = generateSignature({
                "bucketName": this.get('bucket_name'),
                "acl": this.get('storageACL'),
                "name": data.files[0].name,
                "contentType": data.files[0].type,
                "access_key": this.get('access_key'),
                "secret_access_key": this.get('secret_key'),
            });

            this.set('filekey', data.files[0].name);
            this.set('fileaccesskey', this.get('access_key'));
            this.set('filecontenttype', data.files[0].type);
            this.set('filepolicy', sign.policy);
            this.set('filesignature', sign.signature);
            return true;
        });

        $element.on("fileuploadprogress", (e, data) => {
            console.log("-----------------------------------");
            console.log(parseInt(data.loaded / data.total * 100, 10));
            self.set("uploadPercentage", parseInt(data.loaded / data.total * 100, 10));
        });

        $element.on("fileuploadsend", (e, data) => {
            if (data.xhr && data.originalFiles.length === 1) {
                self.set("isCancellable", true);
                self._xhr = data.xhr();
            }
            return true;
        });

        $element.on("fileuploadfail", (e, data) => {
            //this._resetUpload(true);

            //const userCancelled = this._xhr && this._xhr._userCancelled;
            //this._xhr = null;

            //if (!userCancelled) {
            //    Discourse.Utilities.displayErrorForUpload(data);
            //}

        });

    },

    /*_bindUploadTarget() {
        //this._unbindUploadTarget(); // in case it's still bound, let's clean it up first
        const self = this;
        const $element = this.$();
        $element.fileupload({
            url: "",
            pasteZone: $element,
            //forceIframeTransport: true,
            //autoUpload: true,
            dataType: 'xml',
            type: 'POST',
        });

        $element.on('fileuploadsubmit', (e, data) => {
            var sign = generateSignature({
                "bucketName": "tron",
                "acl": this.get('storageACL'),
                "name": data.files[0].name,
                "contentType": data.files[0].type,
                "access_key": "0RE8HB1CTEW0C13QIEEO",
                "secret_access_key": "nS05jbwXswx5x6st1uTy2alIZbwcfvFMQF5CYF0a",
            });
            data.formData = {
                key: data.files[0].name,
                acl: this.get('storageACL'),
                AWSAccessKeyId: "0RE8HB1CTEW0C13QIEEO",
                "content-type": data.files[0].type,
                policy: sign.policy,
                signature: sign.signature
            };
            return true;
        });

        $element.on("fileuploadprogress", (e, data) => {
            self.set("uploadPercentage", parseInt(data.loaded / data.total * 100, 10));
        });

        $element.on("fileuploadsend", (e, data) => {
            if (data.xhr && data.originalFiles.length === 1) {
                self.set("isCancellable", true);
                self._xhr = data.xhr();
            }
            return true;
        });

        $element.on("fileuploadfail", (e, data) => {
            //this._resetUpload(true);

            //const userCancelled = this._xhr && this._xhr._userCancelled;
            //this._xhr = null;

            //if (!userCancelled) {
            //    Discourse.Utilities.displayErrorForUpload(data);
            //}

        });

    },*/

});
