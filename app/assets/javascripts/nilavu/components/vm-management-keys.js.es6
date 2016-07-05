import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('keys', {
    privateKey_suffix: ".key",
    publicKey_suffix: ".pub",
    spinnerPrivateIn: false,
    spinnerPublicIn: false,
    privatekeyType: "PRIVATEKEY",
    publickeyType: "PUBLICKEY",
    privatekey: 'application/x-pem-key',
    publickey: 'text/plain',

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

    showPrivateSpinner: function() {
        return this.get('spinnerPrivateIn');
    }.property('spinnerPrivateIn'),

    showPublicSpinner: function() {
        return this.get('spinnerPublicIn');
    }.property('spinnerPublicIn'),

    _getSuffix(type) {
        if (type == this.get('privatekeyType')) {
            return this.get('privateKey_suffix');
        } else {
            return this.get('publicKey_suffix');
        }
    },

    _getKey(name) {
      alert("2");
      alert(JSON.stringify(name));
        return Nilavu.ajax("/ssh_keys/" + name + ".json", {
            type: 'GET'

        });
    },

    actions: {

        download(key, type) {
        alert("1");
            var self = this
            this.set('spinnerIn', true);
            return self._getKey(key).then(function(result) {
                self.set('spinnerIn', false);
                if (!result.failed) {
                    var blob = null;
                    if (type == self.get('privatekeyType')) {
                        blob = new Blob([result.message.ssh_keys[0].privatekey], {
                            type: self.get('privatekey')
                        })
                    } else {
                        blob = new Blob([result.message.ssh_keys[0].publickey], {
                            type: self.get('publickey')
                        })
                    }
                    Nilavu.saveAs(blob, key + self._getSuffix(type));
                } else {
                    self.notificationMessages.error(result.message);
                }
            }, function(e) {
                self.set('spinnerIn', false);
                return self.notificationMessages.error(I18n.t("ssh_keys.download_error"));
            });
        }

    }

});
