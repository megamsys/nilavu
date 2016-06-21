import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('keys', {

    privateKey_suffix: ".key",
    publicKey_suffix: ".pub",

    content_sshkey_name: function() {
        return I18n.t("vm_management.keys.content_name");
    }.property(),

    content_private_sshkey: function() {
        return I18n.t("vm_management.keys.content_private_sshkey");
    }.property(),

    content_public_sshkey: function() {
        return I18n.t("vm_management.keys.content_public_sshkey");
    }.property(),

    keys_title: function() {
        return I18n.t("vm_management.keys.keys_title");
    }.property(),

    privateKey: function() {
        return this._filterInputs("sshkey");
    }.property('model.inputs'),

    publicKey: function() {
        return this._filterInputs("sshkey");
    }.property('model.inputs'),

    hasOutputs: Em.computed.notEmpty('model.outputs'),

    hasInputs: Em.computed.notEmpty('model.inputs'),

    _filterInputs(key) {
        if (!this.get('hasInputs')) return "";
        if (!this.get('model.inputs').filterBy('key', key)[0]) return "";
        return this.get('model.inputs').filterBy('key', key)[0].value;
    },

    _filterOutputs(key) {
        if (!this.get('hasOutputs')) return "";
        if (!this.get('model.outputs').filterBy('key', key)[0]) return "";
        return this.get('model.outputs').filterBy('key', key)[0].value;
    },

    actions: {

        privatekey_download(key) {
            Nilavu.ajax("/ssh_keys/" + key + ".json", {
                type: 'GET'
            }).then(function(result) {
            //  window.saveAs(new Blob([result[0].privatekey], {type: 'application/x-pem-key'}), key);

            }, function(e) {
                if (e.jqXHR && e.jqXHR.status === 429) {
                    this.notificationMessages.error(I18n.t('login.rate_limit'));
                } else {
                    this.notificationMessages.error(I18n.t('login.error'));
                }
                self.set('loggingIn', false);
            });
        }

    }


});
