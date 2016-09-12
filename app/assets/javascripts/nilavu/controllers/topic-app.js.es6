import BufferedContent from 'nilavu/mixins/buffered-content';
import {spinnerHTML} from 'nilavu/helpers/loading-spinner';
import Topic from 'nilavu/models/topic';
import {popupAjaxError} from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';
import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';

export default Ember.Controller.extend(BufferedContent, {
    needs: ['application',  'modal'],
    privateKey_suffix: ".key",
    spinnerprivateIn: false,
    spinnerpublicIn: false,
    privatekeyType: "PRIVATEKEY",
    privatekey: 'application/x-pem-key',

    hasInputs: Em.computed.notEmpty('model.inputs'),
    hasOutputs: Em.computed.notEmpty('model.outputs'),

    _filterInputs(key) {
        if (!this.get('hasInputs'))
            return "";
        if (!this.get('model.inputs').filterBy('key', key)[0])
            return "";
        return this.get('model.inputs').filterBy('key', key)[0].value;
    },

    _filterOutputs(key) {
        if (!this.get('hasOutputs'))
            return "";
        if (!this.get('model.outputs').filterBy('key', key)[0])
            return "";
        return this.get('model.outputs').filterBy('key', key)[0].value;
    },

    brandImage: function() {
        return `<img src="../../images/brands/ubuntu.png" />`.htmlSafe();
    }.property(),

    showBrandImage: function() {
        const fullBrandUrl = this.get('model.tosca_type');

        if (Em.isNone(fullBrandUrl)) {
            return `<img src="../../images/brands/dummy.png" />`.htmlSafe();
        }

        const split = fullBrandUrl.split('.');

        if (split.length >= 2) {
            var brandImageUrl = split[2];
            return `<img src="../../images/brands/${brandImageUrl}.png" />`.htmlSafe();
        }

        return `<img src="../../images/brands/ubuntu.png" />`.htmlSafe();
    }.property('model.tosca_type'),

    url: function() {
        return this.get('componentData.repo.url');
    }.property('componentData'),

    source: function() {
        return this.get('componentData.repo.source');
    }.property('componentData'),

    title: Ember.computed.alias('fullName'),

    fullName: function() {
        return this.get('model.name')
    }.property('model.name'),

    application: function() {
        return this.get('model.tosca_type').split('.')[2].capitalize();
    }.property('model.tosca_type'),

    publisher: function() {
        return this.get('model.tosca_type').split('.')[0]
    }.property('model.tosca_type'),

    domain: function() {
        return this._filterInputs("domain");
    }.property('model.domain'),

    sshKey: function() {
        return this._filterInputs("sshkey");
    }.property('model.sshkey'),

    cpu_cores: function() {
        return this._filterInputs("cpu");
    }.property('model.inputs'),

    ram: function() {
        return this._filterInputs("ram");
    }.property('model.inputs'),

    componentData: function() {
        return this.get('model.components')[0][0]
    }.property('model.components'),

    privateipv4: function() {
        return this._filterOutputs("privateipv4");
    }.property('model.outputs'),

    _checked(value) {
        if (value == "true") {
            return true;
        } else {
            return false;
        }
    },

    createdAt: function() {
        return new Date(this.get('model.created_at'));
    }.property('model.created_at'),

    status: function() {
        return this.get('model.status.message');
    }.property('model.status'),

    privateKey: function() {
        return this._filterInputs("sshkey");
    }.property('model.inputs'),

    showPrivateSpinner: function() {
        return this.get('spinnerprivateIn');
    }.property('spinnerprivateIn'),

    showPublicSpinner: function() {
        return this.get('spinnerpublicIn');
    }.property('spinnerpublicIn'),

    _getSuffix(type) {
        if (type == this.get('privatekeyType')) {
            return this.get('privateKey_suffix');
        } else {
            return this.get('publicKey_suffix');
        }
    },

    _getKey(name) {
        return Nilavu.ajax("/ssh_keys/" + name + ".json", {type: 'GET'});
    },

    actions: {

        download(key, type) {
            var self = this
            this.set('spinner' + key + 'In', true);
            return self._getKey(key).then(function(result) {
                self.set('spinner' + key + 'In', false);
                if (!result.failed) {
                    var blob = null;
                    if (type == self.get('privatekeyType')) {
                        blob = new Blob([result.message.ssh_keys[0].privatekey], {type: self.get('privatekey')})
                    } else {
                        blob = new Blob([result.message.ssh_keys[0].publickey], {type: self.get('publickey')})
                    }
                    Nilavu.saveAs(blob, key + self._getSuffix(type));
                } else {
                    self.notificationMessages.error(result.message);
                }
            }, function(e) {
                self.set('spinner' + key + 'In', false);
                return self.notificationMessages.error(I18n.t("ssh_keys.download_error"));
            });
        }
    },

});
