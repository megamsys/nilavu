import BufferedContent from 'nilavu/mixins/buffered-content';
import {spinnerHTML} from 'nilavu/helpers/loading-spinner';
import Topic from 'nilavu/models/topic';
import {popupAjaxError} from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';
import NilavuURL from 'nilavu/lib/url';
import showModal from 'nilavu/lib/show-modal';

export default Ember.Controller.extend(BufferedContent, {
    needs: [
        'application', 'modal'
    ],
    progress: 10,
    selectedTab: null,
    panels: null,
    spinnerStartIn: false,
    spinnerStopIn: false,
    spinnerRebootIn: false,
    spinnerDeleteIn: false,
    spinnerRefreshIn: false,
    rerenderTriggers: ['isUploading'],
    privateKey_suffix: ".key",
    spinnerprivateIn: false,
    spinnerpublicIn: false,
    privatekeyType: "PRIVATEKEY",
    privatekey: 'application/x-pem-key',

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'info');
    }.on('init'),

    infoSelected: function() {
        return this.selectedTab == 'info';
    }.property('selectedTab'),

    storageSelected: function() {
        return this.selectedTab == 'storage';
    }.property('selectedTab'),

    networkSelected: function() {
        return this.selectedTab == 'network';
    }.property('selectedTab'),

    cpuSelected: function() {
        return this.selectedTab == 'cpu';
    }.property('selectedTab'),

    ramSelected: function() {
        return this.selectedTab == 'ram';
    }.property('selectedTab'),

    keysSelected: function() {
        return this.selectedTab == 'keys';
    }.property('selectedTab'),

    logsSelected: function() {
        return this.selectedTab == 'logs';
    }.property('selectedTab'),

    title: Ember.computed.alias('fullName'),

    fullName: function() {
        //var js = this._filterInputs("domain");
        //return this.get('model.name') + "." + js;
        return this.get('model.name')
    }.property('model.name'),

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

    showStartSpinner: function() {
        return this.get('spinnerStartIn');
    }.property('spinnerStartIn'),

    showStopSpinner: function() {
        return this.get('spinnerStopIn');
    }.property('spinnerStopIn'),

    showRebootSpinner: function() {
        return this.get('spinnerRebootIn');
    }.property('spinnerRebootIn'),

    showDeleteSpinner: function() {
        return this.get('spinnerDeleteIn');
    }.property('spinnerDeleteIn'),

    showRefreshSpinner: function() {
        return this.get('spinnerRefreshIn');
    }.property('spinnerRefreshIn'),

    getData(reqAction) {
        return {
            id: this.get('model').id, cat_id: this.get('model').asms_id, name: this.get('model').name, req_action: reqAction, cattype: this.get('model').tosca_type.split(".")[1],
            category: "control"
        };
    },

    getDeleteData() {
        return {
            id: this.get('model').id, cat_id: this.get('model').asms_id, name: this.get('model').name, action: "delete", cattype: this.get('model').tosca_type.split(".")[1],
            category: "state"
        };
    },

    delete() {
        var self = this;
        this.set('spinnerDeleteIn', true);
        Nilavu.ajax('/t/' + this.get('model').id + "/delete", {
            data: this.getDeleteData(),
            type: 'DELETE'
        }).then(function(result) {
            self.set('spinnerDeleteIn', false);
            if (result.success) {
                self.notificationMessages.success(I18n.t("vm_management.delete_success"));
            } else {
                self.notificationMessages.error(I18n.t("vm_management.error"));
            }
        }).catch(function(e) {
            self.set('spinnerDeleteIn', false);
            self.notificationMessages.error(I18n.t("vm_management.error"));
        });
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

    name: function() {
        return this.get('model.name');
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

    hasOutputs: Em.computed.notEmpty('model.outputs'),

    hasInputs: Em.computed.notEmpty('model.inputs'),

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

        refresh() {
            const self = this;
            self.set('spinnerRefreshIn', true);
            const promise = this.get('model').reload().then(function(result) {
                self.set('spinnerRefreshIn', false);
            }).catch(function(e) {
                self.notificationMessages.error(I18n.t("vm_management.topic_load_error"));
                self.set('spinnerRefreshIn', false);
            });
        },

        showVNC() {
            const host = this._filterOutputs("vnchost"),
                port = this._filterOutputs("vncport");
            if (host == undefined || host == "" || port == "" || port == undefined) {
                this.notificationMessages.error(I18n.t('vm_management.vnc_host_port_empty'));
            } else {
                showModal('vnc').setProperties({host: host, port: port});
            }

        },

        start() {
            var self = this;
            this.set('spinnerStartIn', true);
            Nilavu.ajax('/t/' + this.get('model').id + "/start", {
                data: this.getData("control"),
                type: 'POST'
            }).then(function(result) {
                self.set('spinnerStartIn', false);
                if (result.success) {
                    self.notificationMessages.success(I18n.t("vm_management.start_success"));
                } else {
                    self.notificationMessages.error(I18n.t("vm_management.error"));
                }
            }).catch(function(e) {
                self.set('spinnerStartIn', false);
                self.notificationMessages.error(I18n.t("vm_management.error"));
            });
        },

        stop() {
            var self = this;
            this.set('spinnerStopIn', true);
            Nilavu.ajax('/t/' + this.get('model').id + "/stop", {
                data: this.getData("control"),
                type: 'POST'
            }).then(function(result) {
                self.set('spinnerStopIn', false);
                if (result.success) {
                    self.notificationMessages.success(I18n.t("vm_management.stop_success"));
                } else {
                    self.notificationMessages.error(I18n.t("vm_management.error"));
                }
            }).catch(function(e) {
                self.set('spinnerStopIn', false);
                console.log(e);
                self.notificationMessages.error(I18n.t("vm_management.error"));
            });
        },

        restart() {
            var self = this;
            this.set('spinnerRebootIn', true);
            Nilavu.ajax('/t/' + this.get('model').id + "/restart", {
                data: this.getData("control"),
                type: 'POST'
            }).then(function(result) {
                self.set('spinnerRebootIn', false);
                if (result.success) {
                    self.notificationMessages.success(I18n.t("vm_management.restart_success"));
                } else {
                    self.notificationMessages.error(I18n.t("vm_management.error"));
                }
            }).catch(function(e) {
                self.set('spinnerRebootIn', false);
                self.notificationMessages.error(I18n.t("vm_management.error"));
            });
        },

        destroy() {
            bootbox.confirm(I18n.t("vm_management.confirm_delete"), result => {
                if (result) {
                    this.delete();
                }
            })
        },

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

    hasError: Ember.computed.or('model.notFoundHtml', 'model.message'),

    noErrorYet: Ember.computed.not('hasError'),

    loadingHTML: function() {
        return spinnerHTML;
    }.property()

});
