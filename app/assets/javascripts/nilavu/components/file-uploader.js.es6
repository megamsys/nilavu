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
    storageAction: null,
    storageKey: null,
    storageACL: 'public-read',
    storageContentType: null,
    storageAccessKeyId: null,
    storagePolicy: null,
    storageSignature: null,

    objectName: null,
    objectSize: null,
    objectIcon: null,

    @on('didInsertElement')
    _initialize() {
        $('#objectfile').trigger('click');
        this._bindUploadTarget();
    },

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

    _bindUploadTarget() {
        //this._unbindUploadTarget(); // in case it's still bound, let's clean it up first
        const self = this;
        const $element = $('#objectfile');
        //alert($element[0].files[0]);
        $element.fileupload({
            url: "http://192.168.0.115/woww",
            dataType: "multipart/form-data",
            pasteZone: $element,
        });

        $element.on('fileuploadsubmit', (e, data) => {
          alert(self.get('storageACL'));
            //const isUploading = Discourse.Utilities.validateUploadedFiles(data.files);
            var sign = generateSignature({
                    "bucketName": "woww",
                    "acl": self.get('storageACL'),
                    "name": data.files[0].name,
                    "access_key": "8EHS3Q80KDVEZ6Q8V74T",
                    "secret_access_key": "dpGcXgNufWYgJcIMvQszyZfnRjqoGBRUPRjCYoUD",
                });
            data.formData = {
                key: data.files[0].name,
                acl: self.get('storageACL'),
                AWSAccessKeyId: "8EHS3Q80KDVEZ6Q8V74T",
                policy: sign.policy,
                signature: sign.signature
            };
            //this.setProperties({
            //    uploadProgress: 0,
            //    isUploading
          //  });
            //return isUploading;
        });

        /*$element.on("fileuploadprogressall", (e, data) => {
            this.set("uploadProgress", parseInt(data.loaded / data.total * 100, 10));
        });*/

        $element.on("fileuploadsend", (e, data) => {
            /*this._validUploads++;
            // add upload placeholders (as much placeholders as valid files dropped)
            const placeholder = _.times(this._validUploads, () => uploadPlaceholder).join("\n");
            this.appEvents.trigger('composer:insert-text', placeholder);
            */
            if (data.xhr && data.originalFiles.length === 1) {
                this.set("isCancellable", true);
                this._xhr = data.xhr();
            }
        });

        $element.on("fileuploadfail", (e, data) => {
            //this._resetUpload(true);

            //const userCancelled = this._xhr && this._xhr._userCancelled;
            //this._xhr = null;

            //if (!userCancelled) {
            //    Discourse.Utilities.displayErrorForUpload(data);
            //}
            alert(e);
            alert(data);
        });

    },

});
