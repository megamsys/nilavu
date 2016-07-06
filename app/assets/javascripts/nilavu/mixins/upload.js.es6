
export default Em.Mixin.create({
    uploading: false,
    uploadProgress: 0,

    _initialize: function() {
        /*const $upload = this.$(),
              csrf = Nilavu.Session.currentProp("csrfToken"),
              uploadUrl = Nilavu.getURL(this.getWithDefault("uploadUrl", "/uploads")),
              reset = () => this.setProperties({ uploading: false, uploadProgress: 0});

        this.messageBus.subscribe("/uploads/" + this.get("type"), upload => {
          if (upload && upload.url) {
            this.uploadDone(upload);
          } else {
            Nilavu.Utilities.displayErrorForUpload(upload);
          }
          reset();
        });

        $upload.fileupload({
          url: uploadUrl + ".json?client_id=" + this.messageBus.clientId + "&authenticity_token=" + encodeURIComponent(csrf),
          dataType: "json",
          dropZone: $upload,
          pasteZone: $upload
        });

        $upload.on("fileuploaddrop", (e, data) => {
          if (data.files.length > 10) {
            bootbox.alert(I18n.t("post.errors.too_many_dragged_and_dropped_files"));
            return false;
          } else {
            return true;
          }
        });

        $upload.on("fileuploadsubmit", (e, data) => {
          const isValid = Nilavu.Utilities.validateUploadedFiles(data.files, true);
          let form = { type: this.get("type") };
          if (this.get("data")) { form = $.extend(form, this.get("data")); }
          data.formData = form;
          this.setProperties({ uploadProgress: 0, uploading: isValid });
          return isValid;
        });

        $upload.on("fileuploadprogressall", (e, data) => {
          const progress = parseInt(data.loaded / data.total * 100, 10);
          this.set("uploadProgress", progress);
        });

        $upload.on("fileuploadfail", (e, data) => {
          Nilavu.Utilities.displayErrorForUpload(data);
          reset();
        }); */
        const $upload = this.$();

        $upload.fileupload({
            url: "",
            dataType: "json",
            dropZone: $upload,
            pasteZone: $upload
        });

        $upload.on("fileuploadsubmit", (e, data) => {
            this._serverConnect();
        });

    }.on("didInsertElement"),

    _destroy: function() {
        this.messageBus.unsubscribe("/uploads/" + this.get("type"));
        const $upload = this.$();
        try {
            $upload.fileupload("destroy");
        } catch (e) { /* wasn't initialized yet */ }
        $upload.off();
    }.on("willDestroyElement"),

    _serverConnect() {
        const self = this;
        const bucketName = "sam";
        this.set('spinnerConnectIn', true);
        Nilavu.ajax('/buckets/' + bucketName, {
            type: 'GET'
        }).then(function(result) {
            if (result.success) {
                self.set('storageAction', result.message.storage_url + '/' + bucketName);
                self.set('storageKey', self.get('objectName'));
                self.set('storageACL', self.get('storageACL'));
                self.set('storageContentType', '');
                self.set('storageAccessKeyId', result.message.access_key_id);
                var sign = generateSignature({
                    "bucketName": "sam",
                    "acl": self.get('storageACL'),
                    "name": self.get('objectName'),
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

});
