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
import UploadMixin from "nilavu/mixins/upload";
export default Ember.Component.extend(UploadMixin, {
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
        $('#objectfile').change(function() {
            var object = $('#objectfile').val();
            this.set('objectName', object[0].files[0].name);
            this.set('objectSize', formatFileSize(object[0].files[0].size));
            var nameSplit = object[0].files[0].name.split('.');
            this.set('objectIcon', formatFileIcons(nameSplit[nameSplit.length - 1]))
        });
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
