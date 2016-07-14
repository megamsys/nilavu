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

    uploadPercentage: 0,
    progressPosition: 0,
    maxProgressPosition: 100,

    @on('didInsertElement')
    _initialize() {
        const self = this;
        $('#objectfile').trigger('click');
        this._bindUploadTarget();
    },

    bucketName: function() {
        return "woww";
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

    /*  _bindUploadTarget() {
          //this._unbindUploadTarget(); // in case it's still bound, let's clean it up first
          const self = this;
          const $element = $("#fileformupload");
          $element.fileupload({
              url: "/b/put",
              autoUpload: true,
              add: function(e, data) {
                  // Automatically upload the file once it is added to the queue
                  var jqXHR = data.submit();
              },

              progress: function(e, data) {
                  // Calculate the completion percentage of the upload
                  var progress = parseInt(data.loaded / data.total * 100, 10);
                  console.log(progress);
              },

              done: function(e, data) {
                  console.log("success------------");
                  console.log(data);
                  console.log(e);
              },

              fail: function(e, data) {
                  console.log("fail------------");
                  console.log(data);
                  console.log(e);
              }
          });

      },*/

    _bindUploadTarget() {
        //this._unbindUploadTarget(); // in case it's still bound, let's clean it up first
        const self = this;
        const $element = this.$();
        $element.fileupload({
            url: "http://192.168.0.115/woww",
            pasteZone: $element,
            forceIframeTransport: true,
            autoUpload: true,
        });

        $element.on('fileuploadsubmit', (e, data) => {
            var sign = generateSignature({
                "bucketName": "woww",
                "acl": this.get('storageACL'),
                "name": data.files[0].name,
                "contentType": data.files[0].type,
                "access_key": "",
                "secret_access_key": "",
            });
            data.formData = {
                key: data.files[0].name,
                acl: this.get('storageACL'),
                AWSAccessKeyId: "",
                "content-type": data.files[0].type,
                policy: sign.policy,
                signature: sign.signature
            };
            return true;
        });

        $element.on("fileuploadprogressall", (e, data) => {
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

});
