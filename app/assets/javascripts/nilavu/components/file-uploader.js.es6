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
import EmberUploader from 'nilavu/lib/file-upload';
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
    signingUrl: '',


    @on('didInsertElement')
    _initialize() {
        const self = this;
        $('#objectfile').trigger('click');
        $('#objectfile').change(function(event) {
                alert(event.target.files[0].name);
                //self._bindS3(event.target);
                self._bindForm(event.target);
            })
            //this._bindUploadTarget();
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

    _bindForm(data) {
        const files = data.files;
        const self = this;
        alert(files[0].name);
        var sign = generateSignature({
            "bucketName": "woww",
            "acl": self.get('storageACL'),
            "name": files[0].name,
            "contentType": files[0].type,
            "access_key": "8EHS3Q80KDVEZ6Q8V74T",
            "secret_access_key": "dpGcXgNufWYgJcIMvQszyZfnRjqoGBRUPRjCYoUD",
        });
        self.set('storageAction', "http://192.168.0.115/woww");
        self.set('storageKey', files[0].name);
        self.set('storageACL', self.get('storageACL'));
        self.set('storageContentType', files[0].type);
        self.set('storageAccessKeyId', "8EHS3Q80KDVEZ6Q8V74T");
        self.set('storagePolicy', sign.policy);
        self.set('storageSignature', sign.signature);
        $.ajax({
            type: "POST",
            url: "http://192.168.0.115/woww",
            data: $("#objectfile").serialize(), // serializes the form's elements.
            cors: false,
            headers: {
                'Access-Control-Allow-Origin': false,
            },
            xhrFields: {
                withCredentials: false
            },
            success: function(data) {
                alert(data); // show response from the php script.
            }
        });

    },

    _bindS3(data) {
        const files = data.files;
        const self = this;
        alert(files[0].name);
        var sign = generateSignature({
            "bucketName": "woww",
            "acl": self.get('storageACL'),
            "name": files[0].name,
            "contentType": files[0].type,
            "access_key": "8EHS3Q80KDVEZ6Q8V74T",
            "secret_access_key": "dpGcXgNufWYgJcIMvQszyZfnRjqoGBRUPRjCYoUD",
        });
        self.set('storageAction', "http://192.168.0.115/woww");
        self.set('storageKey', files[0].name);
        self.set('storageACL', self.get('storageACL'));
        self.set('storageContentType', files[0].type);
        self.set('storageAccessKeyId', "8EHS3Q80KDVEZ6Q8V74T");
        self.set('storagePolicy', sign.policy);
        self.set('storageSignature', sign.signature);
        $('#fileupload').ajaxForm({
            beforeSend: function() {
                //status.empty();
                var percentVal = '0%';
                //  bar.width(percentVal);
                //  percent.html(percentVal);
            },
            uploadProgress: function(event, position, total, percentComplete) {
                var percentVal = percentComplete + '%';
                console.log(percentVal);
                //bar.width(percentVal);
                //  percent.html(percentVal);
            },
            complete: function(xhr) {
                //  status.html(xhr.responseText);
            }
        });
    },

    _bindUploader(data) {
        const files = data.files;
        const uploader = EmberUploader.create({
            url: "http://192.168.0.115/woww",
        });
        alert(files[0].name);
        var sign = generateSignature({
            "bucketName": "woww",
            "acl": self.get('storageACL'),
            "name": files[0].name,
            "contentType": files[0].type,
            "access_key": "8EHS3Q80KDVEZ6Q8V74T",
            "secret_access_key": "dpGcXgNufWYgJcIMvQszyZfnRjqoGBRUPRjCYoUD",
        });
        self.set('storageAction', "http://192.168.0.115/woww");
        self.set('storageKey', files[0].name);
        self.set('storageACL', self.get('storageACL'));
        self.set('storageContentType', files[0].type);
        self.set('storageAccessKeyId', "8EHS3Q80KDVEZ6Q8V74T");
        self.set('storagePolicy', sign.policy);
        self.set('storageSignature', sign.signature);
        var formData = new FormData($('#fileupload')[0]);
        if (!Ember.isEmpty(files)) {
            // this second argument is optional and can to be sent as extra data with the upload
            uploader.upload(files, {
                formdata: formData
            });
        }

        uploader.on('didUpload', e => {
            alert("success");
        });
        uploader.on('didError', (jqXHR, textStatus, errorThrown) => {
            alert(textStatus);
        });
    },

    _bindUploadTarget() {
        //this._unbindUploadTarget(); // in case it's still bound, let's clean it up first
        const self = this;
        const $element = $('#objectfile');
        //alert($element[0].files[0]);
        $element.fileupload({
            url: "http://192.168.0.115/woww",
            //  dataType: "multipart/form-data",
            dataType: 'JSON',
            pasteZone: $element,
            add: function(e, data) {
                data.submit();
            }
        });

        $element.on('fileuploadsubmit', (e, data) => {
            //const isUploading = Discourse.Utilities.validateUploadedFiles(data.files);
            var sign = generateSignature({
                "bucketName": "woww",
                "acl": self.get('storageACL'),
                "name": data.files[0].name,
                "contentType": "application/x-www-form-urlencoded",
                "access_key": "8EHS3Q80KDVEZ6Q8V74T",
                "secret_access_key": "dpGcXgNufWYgJcIMvQszyZfnRjqoGBRUPRjCYoUD",
            });
            console.log(JSON.stringify(sign));
            data.formData = {
                key: data.files[0].name,
                acl: self.get('storageACL'),
                AWSAccessKeyId: "8EHS3Q80KDVEZ6Q8V74T",
                contentType: "application/x-www-form-urlencoded",
                policy: sign.policy,
                signature: sign.signature
            };
            data.headers = {
                    withCredentials: true
                }
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
            console.log(data);
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

        });

    },

    actions: {
        fileDidChange(files) {
            const self = this;
            const uploader = EmberUploader.create({
                url: "http://192.168.0.115/woww",
            });
            alert(files[0].name);
            var sign = generateSignature({
                "bucketName": "woww",
                "acl": self.get('storageACL'),
                "name": files[0].name,
                "contentType": files[0].type,
                "access_key": "8EHS3Q80KDVEZ6Q8V74T",
                "secret_access_key": "dpGcXgNufWYgJcIMvQszyZfnRjqoGBRUPRjCYoUD",
            });
            self.set('storageAction', "http://192.168.0.115/woww");
            self.set('storageKey', files[0].name);
            self.set('storageACL', self.get('storageACL'));
            self.set('storageContentType', files[0].type);
            self.set('storageAccessKeyId', "8EHS3Q80KDVEZ6Q8V74T");
            self.set('storagePolicy', sign.policy);
            self.set('storageSignature', sign.signature);
            var formData = new FormData($('#fileupload')[0]);
            if (!Ember.isEmpty(files)) {
                // this second argument is optional and can to be sent as extra data with the upload
                uploader.upload(files, {
                    formdata: formData
                });
            }

            uploader.on('didUpload', e => {
                alert("success");
            });
            uploader.on('didError', (jqXHR, textStatus, errorThrown) => {
                alert(textStatus);
            });
        },
    }

});
